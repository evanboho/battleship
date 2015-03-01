require 'rails_helper'

describe Board do
  before do
    @board = Board.create
    @board.spaces.destroy_all
    @size = 3
    @boat = Boat.create(name: "jku's boat", size: @size)
  end

  describe '#create_spaces_for_boat' do
    it 'creates spaces for a boat going up' do
      space_candidate = ['j', '1']
      dir = 'up'
      expect {
        @board.create_spaces_for_boat(@boat, space_candidate, dir)
      }.to change { @board.spaces.where(state: 'boat').count }.by(@size)
      expect(@board.spaces.map { |a| a.letter + a.number }).to eq ['j1', 'i1', 'h1']
    end

    it 'returns false and does not create spaces if one is invalid' do
      space_candidate = ['b', 1]
      dir = 'up'
      expect {
        @board.create_spaces_for_boat(@boat, space_candidate, dir)
      }.to_not change { @board.spaces.where(state: 'boat').count }
    end

    it 'creates spaces for a boat going right' do
      space_candidate = ['j', '1']
      dir = 'right'
      expect {
        @board.create_spaces_for_boat(@boat, space_candidate, dir)
      }.to change { @board.spaces.where(state: 'boat').count }.by(@size)
      expect(@board.spaces.map { |a| a.letter + a.number }).to eq ['j1', 'j2', 'j3']
    end

    it 'returns false and does not create spaces if one is invalid going right' do
      space_candidate = ['j', 9]
      dir = 'right'
      expect {
        @board.create_spaces_for_boat(@boat, space_candidate, dir)
      }.to_not change { @board.spaces.where(state: 'boat').count }
    end
  end
end

