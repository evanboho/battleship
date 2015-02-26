class Board < ActiveRecord::Base
  has_many :spaces

  def guess(letter, number)
    space = spaces.guessable_only.find_by_letter_and_number(letter, number)

    if space.blank?
      raise "No guessable spaces at #{letter} #{number}"
    elsif space.open?
      space.update_attributes(state: 'guessed')

      false
    elsif space.boat?
      space.update_attributes(state: 'hit')

      true
    end
  end
end
