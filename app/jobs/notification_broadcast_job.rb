class NotificationBroadcastJob < ApplicationJob

  queue_as :default

  def perform(membership, actor, action)
    service = NotificationService.new membership, actor, action
    service.broadcast
  end

end
