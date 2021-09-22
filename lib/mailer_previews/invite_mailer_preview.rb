class InviteMailerPreview < ActionMailer::Preview

  def invite
    InviteMailer.invite(Invite.first)
  end
end
