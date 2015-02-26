class Game < ActiveRecord::Base
  has_many :boards, autosave: true
  before_create :create_boards

  def create_boards
    Board.create(owner: 'Computer')
    Board.create(owner: 'Human')
  end

end
