class User < ApplicationRecord
  has_many :flashcard_sets, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :collections, dependent: :destroy
  
  has_many :favorites
  has_many :favorite_collections, through: :favorites, source: :collection
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
