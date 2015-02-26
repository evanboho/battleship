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
    LETTERS.map do |letter|
      NUMBERS.map do |number|
        [letter, number]
      end
    end.inject(:+)
  end

end
