class NotificationMailer < ApplicationMailer

  def new_features(user)
    @user = user
    attachments.inline['icon.png'] = File.read(Rails.root.join('app', 'assets', 'images', 'icon.png'))
    mail(to: user.email, subject: 'New Features in SurfApp')
  end

end
