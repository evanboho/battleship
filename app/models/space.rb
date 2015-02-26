class Space < ActiveRecord::Base
  belongs_to :board

  # States
  # boat, guessed, and hit

  scope :boats_only, -> { where(state: "boat") }

  def boat?
    state == 'boat'
  end
end
