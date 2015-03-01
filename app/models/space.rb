class Space < ActiveRecord::Base
  belongs_to :board

  scope :boats, -> { where(state: "boat") }
  scope :hits, -> { where state: 'hit' }
  scope :guessed, -> { where state: 'guessed' }

  def boat?
    state == 'boat'
  end

  def neighbor_coordinates
    %w(up down left right).map do |dir|
      neighbor(dir)
    end.compact
  end

  def neighbor(dir)
    coords = case dir
    when 'up'
      [(letter.ord - 1).chr, number]
    when 'down'
      [(letter.ord + 1).chr, number]
    when 'left'
      [letter, (number.to_i - 1).to_s]
    when 'right'
      [letter, (number.to_i + 1).to_s]
    end
    coords if coords.in? Board.grid
  end

end
