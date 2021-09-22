class NotificationMailerPreview < ActionMailer::Preview

  def new_features
    NotificationMailer.new_features(User.first)
  end
end
