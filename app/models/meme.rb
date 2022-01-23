class Meme < ApplicationRecord

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes,   as: :likeable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
  has_and_belongs_to_many :tags
  has_one_attached :image

  validates :lang, presence: true, length: { minimum: 2, maximum: 2 }, format: { with: /de|en/, message: "only allows en or de"}

=begin
  def make_tag(this_tag)
    tag = Tag.find_by(name: this_tag)
    if tag
      unless self.tags.exists?(tag[:id])
        self.tags << tag
      end
    else
      self.tags.create({name: tag})
    end 
  end
=end
end
