class GamesController < ApplicationController
  before_action :find_game

  def new
  end

  def create
    @game = Game.create
    redirect_to @game
  end

  def show
    @game = Game.find(params[:id])
    spaces_count = @game.boards.map { |a| a.spaces.count }.inject(:+)
    if @game.winner
      @winner = @game.winner
      render 'winner' and return
    end
    if spaces_count # >= Boat.pluck(:size).map(&:to_i).inject(:+) * 2
     render 'show'
    else
     render 'setup'
    end
  end

  def guess
    computer_board_guess = computer_board.guess(*Coords.new(params[:guess]))
    if !computer_board_guess[:state].in? ['invalid guess', 'already guessed']
      guess = Guesser.new(human_board.spaces).run!
      human_board_guess = human_board.guess(*guess)
    else
      human_board_guess = {}
    end
    respond_to do |format|
      format.html { redirect_to @game }
      format.json do
        json = { computer_board: computer_board_guess, human_board: human_board_guess }
        render json: json
      end
    end
  end

  def add_boat
    @game = Game.find(params[:id])
    boat = Boat.find_by name: params[:boat_name]
    board = @game.boards.find_by owner: 'Human'
    if board.create_spaces_for_boat boat, params[:letter] + params[:number], 'right'
      redirect_to @game
    else
      redirect_to @game, flash: 'Something went wrong'
    end
  end


  private

  def find_game
    @game = Game.find(params[:id]) if params[:id]
  end

  def computer_board
    @computer_board ||= @game.boards.detect { |a| a.owner == 'Computer' }
  end

  def human_board
    @human_board ||= @game.boards.detect { |a| a.owner == 'Human' }
  end

end
