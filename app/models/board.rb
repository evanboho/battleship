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
    @current_occupied_spaces ||= spaces.where(state: 'board').to_a.map { |a| a.letter + a.number }
  end

  def create_spaces_for_boat(boat, space_candidate, dir)
    boat_spaces = [space_candidate]
    if dir == 'up'
      (boat.size.to_i - 1).times do
        letter = space_candidate[0]
        prev_letter = (letter.ord - 1).chr
        space_candidate = [prev_letter, space_candidate[1]]

        if self.class.grid.include?(space_candidate) && !current_occupied_spaces.include?(space_candidate)
          boat_spaces << space_candidate
        else
          return false
        end
      end
    elsif dir == 'right'
      (boat.size.to_i - 1).times do
        number = space_candidate[1].to_i
        space_candidate = [space_candidate[0], number + 1]
        if self.class.grid.include?(space_candidate) && !current_occupied_spaces.include?(space_candidate)
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
        [letter, number]
      end
    end
  end

  def guess(letter, number)
    space = spaces.guessable_only.find_by_letter_and_number(letter, number)

    if space.blank?
      raise "No guessable spaces at #{letter} #{number}"
    elsif space.open?
      space.update_attributes(state: 'guessed')

      false
    elsif space.boat?
      space.update_attributes(state: 'hit')

      true
    end
  end

end
