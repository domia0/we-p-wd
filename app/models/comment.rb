class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :meme
  has_many :likes,   as: :likeable, dependent: :destroy
  has_many :reports, as: :reportable

  validates :body, presence: true
  
end
