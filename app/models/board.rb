class Board < ActiveRecord::Base
  has_many :spaces, autosave: true
  after_create :add_boats #, if: -> { owner == 'Computer' }
  LETTERS = ('a'..'j')
  NUMBERS = (1..10)

  def add_boats
    Boat.all.each do |boat|
      add_boat(boat)
    end
    space_coords = spaces.boats.map { |a| [a.letter, a.number] }
    raise 'Wrong number of spaces' if space_coords.count != space_coords.uniq.count
  end

  def add_boat(boat)
    space_candidate = self.class.grid.shuffle.first
    dir = %w(up right).shuffle.first
    created_spaces = create_spaces_for_boat(boat, space_candidate, dir)
    add_boat(boat) unless created_spaces
  end

  def current_occupied_spaces
    @current_occupied_spaces ||= spaces.select { |s| s.state == 'boat' }.map { |a| a.letter + a.number }
  end

  def hit_spaces
    @hit_spaces ||= spaces.select { |s| s.state == 'hit' }.map { |a| a.letter + a.number }
  end

  def guessed_spaces
    @guessed_spaces ||= spaces.select { |s| s.state == 'guessed' }.map { |a| a.letter + a.number }
  end

  def create_spaces_for_boat(boat, space_candidate, dir)
    occ_spaces = spaces.where(state: 'boat')
    occ_space_coords = occ_spaces.map { |a| [a.letter, a.number] }
    occ_space_neighbors = occ_spaces.map(&:neighbor_coordinates).inject(:+) || []
    return if space_candidate.in?(occ_space_coords) || space_candidate.in?(occ_space_neighbors)
    boat_spaces = [Space.new(letter: space_candidate[0], number: space_candidate[1], state: 'boat')]
    (boat.size.to_i - 1).times do
      neighbor_coords = boat_spaces.last.neighbor(dir)
      if neighbor_coords && !neighbor_coords.in?(occ_space_coords) && !neighbor_coords.in?(occ_space_neighbors)
        boat_spaces << Space.new(letter: neighbor_coords[0], number: neighbor_coords[1], state: 'boat')
      end
    end
    if boat_spaces.size == boat.size.to_i
      boat_spaces.map do |space|
        self.spaces << space
      end
    end
  end

  def self.grid
    unflat_grid.inject(:+)
  end

  def self.unflat_grid
    NUMBERS.map do |number|
      LETTERS.map do |letter|
        [letter, number.to_s]
      end
    end
  end

  def guess(letter, number)
    return_hash = { letter: letter, number: number }
    if !self.class.grid.include?([letter, number])
      return_hash[:state] = 'invalid guess'
      return return_hash
    end

    existing_space = spaces.find_by letter: letter, number: number
    if existing_space.blank?
      spaces.create(state: 'guessed', letter: letter, number: number)
      return_hash[:state] = 'guessed'
    elsif existing_space.boat?
      existing_space.update_attributes(state: 'hit')
      return_hash[:state] = 'hit'
    else
      return_hash[:state] = 'already guessed'
    end
    return_hash
  end

  def random_guess
    random_guess_against_human = (Board.grid - spaces.map { |a| a.letter + a.number }).sample
    letter = random_guess_against_human[0]
    number = random_guess_against_human[1]
    begin
      guess letter, number
    rescue
      random_guess
    end
  end

  def educated_guess
    all_spaces = spaces.where.not(state: 'boat').map { |a| [a.letter, a.number] }
    available_neighbors = []
    spaces.hits.each do |hit_space|
      available_neighbors = hit_space.neighbor_coordinates - all_spaces
      break if available_neighbors.present?
    end
    available_neighbors[0]
  end

end
