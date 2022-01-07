class Tag < ApplicationRecord

  has_and_belongs_to_many :memes

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }, uniqueness: true
end
