class Collection < ApplicationRecord
    belongs_to :user
    has_many :flashcard_sets, dependent: :destroy
    
    has_many :favorites
    has_many :favorited_by_users, through: :favorites, source: :user
end