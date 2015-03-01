class Game < ActiveRecord::Base
  has_many :boards, autosave: true
  before_create :create_boards

  def create_boards
    boards.new(owner: 'Computer')
    boards.new(owner: 'Human')
  end

  def winner
    human_boats_remaining = boards.find_by(owner: 'Human').spaces.boats.count
    computer_boats_remaining = boards.find_by(owner: 'Computer').spaces.boats.count
    return 'Tie' if human_boats_remaining + computer_boats_remaining == 0
    return 'Human' if computer_boats_remaining == 0
    return 'Computer' if human_boats_remaining == 0
  end

end
