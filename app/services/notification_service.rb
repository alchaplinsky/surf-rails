class NotificationService

  attr_reader :object, :actor, :action

  def initialize(object, actor, action)
    @object = object
    @actor = actor
    @action = action
  end

  def broadcast
    case @object.class.name
    when 'InterestMembership'
      broadcast_membership_notification
    when 'Submission'
      broadcast_submission_notifications
    else
      raise NotImplementedError
    end
  end

  protected

  def broadcast_membership_notification
    id = object.user_id == actor.id ? interest.owner.id : object.user_id
    broadcast_notification channel_name(id), Notifications::InterestMembershipPresenter
  end

  def broadcast_submission_notifications
    user_ids = interest.users.excl(actor).pluck(:id)
    user_ids.each do |user_id|
      broadcast_notification channel_name(user_id), Notifications::SubmissionPresenter
    end
  end

  def broadcast_notification(channel, presenter_class)
    ActionCable.server.broadcast channel, data: presenter_class.new(
      object, interest, actor, action
    ).as_json
  end

  def interest
    @interest ||= Interest.find @object.interest_id
  end

  def channel_name(id)
    "notifications_#{id}_channel"
  end

end
