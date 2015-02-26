class Space < ActiveRecord::Base
  belongs_to :board

  # States
  # boat, guessed, and hit
  # null => open

  scope :guessable_only, -> { where("state IS NULL or state = 'boat'") }

  def open?
    state.nil?
  end

  def boat?
    state == 'boat'
  end
end
