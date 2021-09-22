class Api::Interests::BasePresenter < BasePresenter

  attributes :id, :user_id, :name, :posts_count, :shared, :membership

  def posts_count
    object.submissions.size
  end

  def shared
    object.interest_memberships.size > 1
  end

  def membership
    return nil unless interest_membership.present?
    {
      id: interest_membership.id,
      role: interest_membership.role
    }
  end

  private

  def interest_membership
    @interest_membership ||= object.interest_memberships.where(user: current_user).first
  end

  def current_user
    arguments[:current_user]
  end

end
