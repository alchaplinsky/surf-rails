class Api::InterestMembershipPresenter < BasePresenter
  attributes :id, :interest_id, :user, :role

  def user
    Api::UserPresenter.new object.user
  end

end
