class InterestMembership < ApplicationRecord

  validates_presence_of :interest, :user, :role
  validates_uniqueness_of :user_id, scope: :interest_id

  belongs_to :interest
  belongs_to :user

  scope :by_role, -> (role) { where(role: role) }

end
