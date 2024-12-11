class User < ApplicationRecord
  has_many :flashcard_sets, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :collections, dependent: :destroy
  
  has_many :favorites
  has_many :favorite_collections, through: :favorites, source: :collection
  
  has_many :hidden_flashcards
  has_many :cards, through: :hidden_cards

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
