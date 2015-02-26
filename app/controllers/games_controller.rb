class GamesController < ApplicationController

  def new
  end

  def create
    @game = Game.create
    redirect_to @game
  end

  def show
    @game = Game.find(params[:id])
    spaces_count = @game.boards.map { |a| a.spaces.count }.inject(:+)
    if spaces_count == Boat.pluck(:size).map(&:to_i).inject(:+) * 2
     render 'show'
    else
     render 'setup'
    end
    #if spaces_count == Boat.pluck(:size).inject(:+) * 2
    # render 'show'
    #else
    # render 'setup'
    #end
  end

  def guess
    @game = Game.find(params[:id])
    guess = params[:guess].split('')
    letter = guess[0]
    number = guess[1]

    computer_board = @game.boards.find_by(owner: 'Computer')

    computer_board.guess(letter, number)

    redirect_to @game
  end

  def add_boat
    @game = Game.find(params[:id])
    boat = Boat.find_by name: params[:boat_name]
    board = @game.boards.find_by owner: 'Human'
    byebug
    if board.create_spaces_for_boat boat, params[:letter] + params[:number], 'right'
      redirect_to @game
    else
      redirect_to @game, flash: 'Something went wrong'
    end
  end

end
