class GamesController < ApplicationController

  def new
  end

  def create
    @game = Game.create
    redirect_to @game
  end

  def show
    @game = Game.find(params[:id])
    render 'show'
    #if @game.started
    #  render 'show'
    #else
    #  render 'setup'
    #end
  end

  def guess
    byebug

    redirect_to :show
  end

  def add_boat
    @game = Game.find(params[:id])
    boat = Boat.find_by name: params[:name]
    board = @game.boards.find_by owner: 'Human'
    board.create_spaces_for_boat boat, params[:space].split('')
  end

end
