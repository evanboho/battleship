class Board < ActiveRecord::Base
  has_many :spaces
  after_create :add_boats, if: -> { owner == 'Computer' }
  LETTERS = ('a'..'j')
  NUMBERS = (1..10)

  def add_boats
    Boat.all.each do |boat|
      add_boat(boat)
    end
  end

  def add_boat(boat)
    space = grid.shuffle.first
    dir = %(up right).shuffle.first
    valid = create_spaces_for_boat(boat, space, dir)
    add_boat(boat) if !valid
  end

  def create_spaces_for_boat(boat, space, dir)
    boat_spaces = [space]
    if dir == 'up'
      (boat.size - 1).times do
        letter = space[0]
        prev_letter = (letter.ord - 1).chr
        space = [prev_letter, space[1]]
        boat_spaces << space
      end
    elsif dir == 'right'
      (boat.size - 1).times do

      end
    end
  end

  def self.grid
    unflat_grid.inject(:+)
  end

  def self.unflat_grid
    LETTERS.map do |letter|
      NUMBERS.map do |number|
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
