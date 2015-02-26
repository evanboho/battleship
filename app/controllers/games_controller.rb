class GamesController < ApplicationController

  def new
  end

  def create
    @game = Game.create
    redirect_to @game
  end

  def show
    @game = Game.find(params[:id])
    if @game.started
      render 'show'
    else
      render 'setup'
    end
  end

end
