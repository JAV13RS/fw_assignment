class HiddenFlashcard < ApplicationRecord
  belongs_to :user
  belongs_to :flashcard

  scope :hidden_for_user, ->(user_id) { where(user_id: user_id, hidden: true) }

end
