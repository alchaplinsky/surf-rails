class Tag < ApplicationRecord

  belongs_to :user
  has_many :taggings, inverse_of: :tag, dependent: :destroy
  has_many :submissions, through: :taggings
  validates_presence_of :user, :name
  validates_uniqueness_of :name, scope: :user_id

  scope :by_query, -> (query) {
    where('name LIKE ?', "#{query}%")
      .group('name')
      .order('count_name desc')
      .count('name')
  }

end
