class Interest < ApplicationRecord

  belongs_to :user
  has_many :submissions, inverse_of: :interest, dependent: :destroy
  has_many :interest_memberships, inverse_of: :interest, dependent: :destroy
  has_many :users, through: :interest_memberships
  has_many :taggings, through: :submissions
  has_many :tags, through: :taggings

  validates_presence_of :user
  validates :name, presence: true
  validates :name, length: { maximum: 24 }
  validates :name, uniqueness: { scope: :user_id }
  validate :plan_limitations

  def owner
    users.merge(InterestMembership.by_role('owner')).first
  end

  def shared?
    interest_memberships.count > 1
  end

  def plan_limitations
    unless user.try(:within_interest_limit?)
      errors.add(:base, 'Free users can only create 10 interests')
    end
  end

end
