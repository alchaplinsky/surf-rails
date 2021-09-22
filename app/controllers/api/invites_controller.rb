class Api::InvitesController < Api::BaseController
  def index
    render json: Api::InvitePresenter.map(current_user.invites)
  end

  def create
    @invite = current_user.invites.build invite_params.merge!(status: 'pending')
    if @invite.save
      InviteMailer.invite(@invite).deliver_later
      render json: { email: @invite.email }
    else
      render_error Api::Errors::ValidationPresenter.new(@invite.errors.messages)
    end
  end

  protected

  def invite_params
    params.require(:invite).permit(:email)
  end

end
