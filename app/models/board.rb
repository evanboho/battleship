class Board < ActiveRecord::Base
  has_many :spaces
  after_create :add_boats, if: -> { owner == 'Computer' }

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

  end

  def self.grid
    ('a'..'j').map do |letter|
      (1..10).map do |number|
        [letter, number]
      end
    end
  end

end
