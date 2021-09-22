class InviteMailer < ApplicationMailer

  def invite(invite)
    @invite = invite
    attachments.inline['icon.png'] = File.read(Rails.root.join('app', 'assets', 'images', 'icon.png'))
    mail(to: invite.email, subject: 'Invitation to join SurfApp.io')
  end

end
