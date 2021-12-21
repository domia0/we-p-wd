class Meme < ApplicationRecord

  belongs_to :user
  has_many :comments
  has_many :likes,   as: :likeable
  has_many :reports, as: :reportable
  has_and_belongs_to_many :tags

  validates :lang, presence: true, length: { minimum: 2, maximum: 2 }
  
end
