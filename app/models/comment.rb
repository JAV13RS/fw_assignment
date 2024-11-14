class Comment < ApplicationRecord
  belongs_to :flashcard_set
  belongs_to :user
end
