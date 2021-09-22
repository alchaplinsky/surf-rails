class Invite < ApplicationRecord

  belongs_to :user, inverse_of: :invites

  validates_presence_of :user, :email, :status, :token
  validates :status, inclusion: { in: %w(pending accepted declined) }
  validates :email, email: true
  validates_uniqueness_of :email, scope: :status
  validate :user_not_exist, on: :create

  before_validation :generate_token, on: :create

  scope :pending, -> { where(status: 'pending') }

  def generate_token
    self.token = SecureRandom.hex(10)
  end

  def user_not_exist
    errors.add :email, :user_exist if User.find_by_email(email)
  end

  def accept!
    update_column(:status, 'accepted')
  end

end
