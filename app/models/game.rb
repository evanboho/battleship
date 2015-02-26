class Game < ActiveRecord::Base
  has_many :boards, autosave: true
  before_create :create_boards

  def create_boards
    boards.new(owner: 'Computer')
    boards.new(owner: 'Human')
  end

end
