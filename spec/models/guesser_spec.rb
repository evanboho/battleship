require 'rails_helper'

describe Guesser do

  before do
    @board = Board.create(owner: 'Human')
  end

  it 'guesses randomly on a blank board' do
    guesser = Guesser.new(@board.spaces)
    expect(guesser).to receive(:random)
    guesser.run!
  end

  describe '#educated' do
    it 'guesses any neighbor if finds single hit' do
      @board.spaces.destroy_all
      hit = @board.spaces.create(letter: 'e', number: '5', state: 'hit')
      guesser = Guesser.new(@board.spaces)
      expect(guesser).to_not receive(:random)
      guess = guesser.run!
      expect(guess.in? hit.neighbor_coordinates).to be true
    end

    it 'guesses opposite neighbor if finds 2 adjacent hits' do
      hit = @board.spaces.boats.last
      hit.update(state: 'hit')
      neighbor = @board.spaces.boats.detect { |boat| [boat.letter, boat.number].in? hit.neighbor_coordinates }
      neighbor.update(state: 'hit')
      dir = hit.which_neighbor(neighbor)
      opp_dir = Space.get_opposite_direction(dir)
      guesser = Guesser.new(@board.spaces)
      guess = guesser.run!
      expect([hit.neighbor(opp_dir), neighbor.neighbor(dir)]).to include guess
    end

    it 'guesses in a line until both ends are misses' do
      @board.spaces.destroy_all
      @board.spaces.create(letter: 'e', number: '5', state: 'hit')
      @board.spaces.create(letter: 'f', number: '5', state: 'hit')
      guesser = Guesser.new(@board.spaces)
      expect {
        guesser.run!
        @board.guess(*guesser.run!)
      }.to change { @board.spaces.guessed.count }.by(1)
      expect(@board.spaces.map(&:coords)).to match_array [['d', '5'], ['e', '5'], ['f', '5']]
      guesser = Guesser.new(@board.reload.spaces)
      expect {
        guesser.run!
        @board.guess(*guesser.run!)
      }.to change { @board.spaces.guessed.count }.by(1)
      expect(@board.spaces.map(&:coords)).to match_array [['e', '5'], ['f', '5'], ['d', '5'], ['g', '5']]
    end
  end

  it 'calculates loners' do
    coords = Coords.new(['e', '5'])
    coords.neighbors.each do |neighbor|
      @board.spaces.create(state: 'guessed', letter: neighbor.letter, number: neighbor.number)
    end
    guesser = Guesser.new(@board.spaces)
    expect(guesser.loners).to eq [coords]
    expect(guesser.viable_spaces).to_not include coords
  end
end
