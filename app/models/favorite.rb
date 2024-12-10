class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :collection

  validates :user_id, uniqueness: { scope: :collection_id, message: "You can only favorite a collection once." }
end
