class Flashcard < ApplicationRecord
  belongs_to :flashcard_set
  
  has_many :hidden_flashcards
  has_many :users, through: :hidden_cards

end
