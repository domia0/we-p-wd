class Meme < ApplicationRecord

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes,   as: :likeable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
  has_and_belongs_to_many :tags
  has_one_attached :image

  validates :lang, presence: true, length: { minimum: 2, maximum: 2 }, format: { with: /de|en/, message: "only allows en or de"}

  def tags_attr(tags)
    tags.each do |t,n|
      tag = Tag.find_by(name: n[:name])
      if tag
        self.tags << tag unless self.tags.exists?(tag[:id])
      else
        self.tags.create({name: n[:name]})
      end 
    end  
  end
end
