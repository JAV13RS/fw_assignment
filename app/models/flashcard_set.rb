class FlashcardSet < ApplicationRecord
    # belongs_to :user, foreign_key: "user_id"
    has_many :flashcards, dependent: :destroy
    has_many :comments, dependent: :destroy
end
