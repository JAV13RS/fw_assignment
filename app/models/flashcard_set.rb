class FlashcardSet < ApplicationRecord
    belongs_to :user
    has_many :flashcards, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_and_belongs_to_many :collections
end
