require 'rails_helper'

describe Board do
  before do
    @board = Board.create
    @size = 3
    @boat = Boat.create(name: "jku's boat", size: @size)
  end

  describe "#create_spaces_for_boat" do
    it "creates spaces for a boat going up" do
      expect do
        space_candidate = ["j", 1]

        dir = "up"

        @board.create_spaces_for_boat(@boat, space_candidate, dir)
      end.to change { @board.spaces.where(state: "boat").count}.by(@size)
    end

    it "returns false and does not create spaces if one is invalid" do
      expect do
        space_candidate = ["b", 1]

        dir = "up"

        @board.create_spaces_for_boat(@boat, space_candidate, dir)
      end.to_not change { @board.spaces.where(state: "boat").count}
    end

    it "creates spaces for a boat going right" do
      expect do
        space_candidate = ["j", 1]

        dir = "right"

        @board.create_spaces_for_boat(@boat, space_candidate, dir)
      end.to change { @board.spaces.where(state: "boat").count}.by(@size)
    end

    it "returns false and does not create spaces if one is invalid going right" do
      expect do
        space_candidate = ["j", 9]

        dir = "right"

        @board.create_spaces_for_boat(@boat, space_candidate, dir)
      end.to_not change { @board.spaces.where(state: "boat").count}
    end
  end
end

