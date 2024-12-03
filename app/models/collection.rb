class Collection < ApplicationRecord
    belongs_to :user
    has_many :flashcard_sets, dependent: :destroy
end