class Board < ActiveRecord::Base
  has_many :spaces
  after_create :add_boats #, if: -> { owner == 'Computer' }
  LETTERS = ('a'..'j')
  NUMBERS = (1..10)

  def add_boats
    Boat.all.each do |boat|
      add_boat(boat)
    end
  end

  def add_boat(boat)
    space_candidate = self.class.grid.shuffle.first
    dir = %w(up right).shuffle.first
    valid = create_spaces_for_boat(boat, space_candidate, dir)
    add_boat(boat) if !valid
  end

  def current_occupied_spaces
    @current_occupied_spaces ||= spaces.where(state: 'boat').to_a.map { |a| a.letter + a.number }
  end

  def hit_spaces
    @hit_spaces ||= spaces.where(state: 'hit').to_a.map { |a| a.letter + a.number }
  end

  def guessed_spaces
    @guessed_spaces ||= spaces.where(state: 'guessed').to_a.map { |a| a.letter + a.number }
  end

  def create_spaces_for_boat(boat, space_candidate, dir)
    occ_spaces = spaces.where(state: 'boat').to_a.map { |a| a.letter + a.number }
    boat_spaces = [space_candidate]
    if dir == 'up'
      (boat.size.to_i - 1).times do
        letter = space_candidate[0]
        prev_letter = (letter.ord - 1).chr
        space_candidate = [prev_letter, space_candidate[1]]

        if self.class.grid.include?(space_candidate) && !occ_spaces.include?(space_candidate.join(''))
          boat_spaces << space_candidate
        else
          return false
        end
      end
    elsif dir == 'right'
      (boat.size.to_i - 1).times do
        number = space_candidate[1].to_i
        space_candidate = [space_candidate[0], number + 1]
        if self.class.grid.include?(space_candidate) && !occ_spaces.include?(space_candidate.join(''))
          boat_spaces << space_candidate
        else
          return false
        end
      end
    end

    boat_spaces.each do |space_candidate|
      spaces.create(letter: space_candidate[0], number: space_candidate[1], state: "boat")
    end
    true
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
    raise 'Guess not on the board' if !self.class.grid.include?([letter, number])

    existing_space = spaces.find_by letter: letter, number: number
    if existing_space.blank?
      spaces.create(state: 'guessed', letter: letter, number: number)
      false
    elsif existing_space.boat?
      existing_space.update_attributes(state: 'hit')
      true
    else
      raise "Already guessed" if existing_space.state != 'boat'
    end
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
