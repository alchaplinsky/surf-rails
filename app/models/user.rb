class User < ApplicationRecord
  ADMIN_EMAILS = %w( alchaplinsky@gmail.com )
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  validates_presence_of :first_name, :last_name, :api_token, :uid, :provider
  validates_inclusion_of :premium, in: [true, false]

  has_many :interest_memberships, inverse_of: :user, dependent: :destroy
  has_many :interests, through: :interest_memberships
  has_many :own_interests, -> { InterestMembership.by_role('owner') }, through: :interest_memberships, source: :interest
  has_many :submissions, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :active_tags, through: :submissions, source: :tags
  has_many :invites, dependent: :destroy
  has_many :upgrades, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  scope :by_name_or_email, -> (query) {
    where('first_name ILIKE ? or last_name ILIKE ? or email ILIKE ?', query, query, query)
  }
  scope :excl, -> (user) { where.not(id: user.id) }

  def managed_memberships
    InterestMembership.where(interest_id: own_interests.map(&:id), role: 'member')
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    ADMIN_EMAILS.include?(email)
  end

  def plan
    premium? ? 'premium' : 'free'
  end

  def within_interest_limit?
    original_user || not_exceeding_limit
  end

  private

  def original_user
    created_at < Time.new('2019-05-18')
  end

  def not_exceeding_limit
    interests.count < Settings.plans.send(:"#{plan}").interests_limit
  end
end
