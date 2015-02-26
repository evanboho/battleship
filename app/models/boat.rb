class Boat < ActiveRecord::Base
  BOATS = [
    { name: 'Aircraft Carrier', size: 5 },
    { name: 'Battleship', size: 4 },
    { name: 'Submarine', size: 3 },
    { name: 'Destroyer', size: 3 },
    { name: 'Patrol Boat', size: 2 }
  ]

  def self.generate_boats
    BOATS.each do |boat_attrs|
      find_or_create_by boat_attrs
    end
  end
end
