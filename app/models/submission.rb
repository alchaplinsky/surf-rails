class Submission < ApplicationRecord
  include Hashid::Rails

  validates_presence_of :interest, :user
  validates_presence_of :text, if: :should_contain_text?

  belongs_to :user
  belongs_to :interest
  has_one :link, inverse_of: :submission, dependent: :destroy
  has_one :note, inverse_of: :submission,  dependent: :destroy
  has_one :image, inverse_of: :submission,  dependent: :destroy
  has_one :attachment, inverse_of: :submission,  dependent: :destroy
  has_many :taggings, inverse_of: :submission, dependent: :destroy
  has_many :tags, through: :taggings

  accepts_nested_attributes_for :link, :note, :image, :attachment

  def tag_list=(tagnames)
    self.tags = tagnames.map do |name|
      interest.owner.tags.where(name: name.downcase).first_or_create!
    end
  end

  private

  def should_contain_text?
    !link && !image && !attachment
  end
end
