class Collection < ApplicationRecord
    belongs_to :user
    has_and_belongs_to_many :flashcard_sets
  end