class Notifications::InterestMembershipPresenter < Notifications::BasePresenter

  def type
    action = @action == :create ? 'created' : 'deleted'
    "interest_membership:#{action}"
  end

  def body
    if @object.user == @actor
      "Has left interest &#{@interest.name}"
    else
      action = @action == :create ? 'shared' : 'unshared'
      "Has #{action} interest &#{@interest.name} with you"
    end
  end

end
