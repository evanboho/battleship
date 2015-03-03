require 'rails_helper'

describe Space do

  describe 'neighbor_coordinates' do
    it 'returns neighbors array if on grid' do
      s = Space.new(letter: 'a', number: '1')
      expect(s.neighbor_coordinates).to match_array [['a', '2'], ['b', '1']]
      s = Space.new(letter: 'b', number: '1')
      expect(s.neighbor_coordinates).to match_array [['a', '1'], ['b', '2'], ['c', '1']]
      s = Space.new(letter: 'c', number: '2')
      expect(s.neighbor_coordinates).to match_array [['b', '2'], ['c', '1'], ['c', '3'], ['d', '2']]
    end
  end

  describe 'which_neighbor' do
    it 'gets up neighbor' do
      space = Space.new(letter: 'd', number: '3')
      neighbor_space = Space.new(letter: 'c', number: '3')
      expect(space.which_neighbor(neighbor_space)).to eq 'up'
    end

    it 'gets down neighbor' do
      space = Space.new(letter: 'c', number: '3')
      neighbor_space = Space.new(letter: 'd', number: '3')
      expect(space.which_neighbor(neighbor_space)).to eq 'down'
    end

    it 'gets left neighbor' do
      space = Space.new(letter: 'e', number: '4')
      neighbor_space = Space.new(letter: 'e', number: '3')
      expect(space.which_neighbor(neighbor_space)).to eq 'left'
    end

    it 'gets right neighbor' do
      space = Space.new(letter: 'e', number: '4')
      neighbor_space = Space.new(letter: 'e', number: '5')
      expect(space.which_neighbor(neighbor_space)).to eq 'right'
    end
  end
end
