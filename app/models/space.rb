class Space < ActiveRecord::Base
  belongs_to :board

  scope :boats, -> { where(state: "boat") }
  scope :hits, -> { where state: 'hit' }
  scope :guessed, -> { where state: 'guessed' }

  def self.get_opposite_direction(dir)
    case dir
    when 'up'; 'down'
    when 'down'; 'up'
    when 'right'; 'left'
    when 'left'; 'right'
    end
  end

  def boat?
    state == 'boat'
  end

  def coords
    @coords ||= Coords.new [letter, number]
  end

  def neighbor_coordinates
    neighbor_coordinates_hash.values.compact
  end

  def neighbor(dir)
    neighbor_coords = coords.neighbor(dir)
    neighbor_coords if neighbor_coords.in?(Board.grid)
  end

  def neighbor_coordinates_hash
    %w(up down left right).inject({}) do |hash, dir|
      hash[dir] = neighbor(dir)
      hash
    end
  end

  def which_neighbor(space)
    detect = neighbor_coordinates_hash.to_a.detect do |nc|
      nc[1] == [space.letter, space.number]
    end
    detect[0] if detect
  end

  def opposite_neighbor_coord(dir)
    neighbor(self.class.get_opposite_direction(dir))
  end

end
