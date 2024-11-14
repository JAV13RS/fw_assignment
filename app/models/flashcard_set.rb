class FlashcardSet < ApplicationRecord
    has_many :flashcards, dependent: :destroy
end
