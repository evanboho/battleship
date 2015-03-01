class Space < ActiveRecord::Base
  belongs_to :board

  # States
  # boat, guessed, and hit

  scope :boats, -> { where(state: "boat") }
  scope :hits, -> { where state: 'hit' }

  def boat?
    state == 'boat'
  end

  def neighbor_coordinates
    %w(up down left right).map do |dir|
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
    end.compact
  end

end
