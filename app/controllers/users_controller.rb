class UsersController < ApplicationController

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes user_update_params
      flash[:notice] = 'Account successfully updated'
    else
      flash[:alert] = @user.errors.full_messages.first
    end
    redirect_to settings_path
  end

  def create
    @service = Oauth::BaseService.new
    @user = @service.create_from_params user_create_params, session['invite']
    if @user.persisted?
      sign_in @user
      flash[:notice] = 'Successfully created account'
      redirect_to dashboard_path
    else
      render 'users/complete'
    end
  end

  private

  def user_create_params
    params.require(:user).permit(:provider, :uid, :first_name, :last_name, :email, :remote_avatar_url).merge!(
      password: Devise.friendly_token[0,20],
      api_token: Devise.friendly_token[0,20]
    )
  end

  def user_update_params
    params.require(:user).permit(:first_name, :last_name)
  end

end
