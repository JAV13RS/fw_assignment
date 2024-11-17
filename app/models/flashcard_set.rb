class FlashcardSet < ApplicationRecord
    belongs_to :user
    has_many :flashcards, dependent: :destroy
    has_many :comments, dependent: :destroy
    belongs_to :collection, optional: true
end
