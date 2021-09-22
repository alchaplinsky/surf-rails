class CallbacksController < Devise::OmniauthCallbacksController

  def facebook
    process_oauth Oauth::FacebookService, 'Facebook'
  end

  def google_oauth2
    process_oauth Oauth::GoogleService, 'Google'
  end

  def failure
    set_flash_message :alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message
    redirect_to root_path
  end

  protected

  def process_oauth(strategy, kind)
    @service = strategy.new
    @user = @service.find_or_create_from_oauth(request.env['omniauth.auth'], invite_token)
    if @user and @user.persisted?
      authorize_and_redirect(kind)
    else
      session['invite'] = invite_token
      render 'users/complete'
    end
  end

  def authorize_and_redirect(kind)
    if request.env['omniauth.params']['client'] == Settings.desktop_client_id
      sign_in @user
      redirect_to client_session_success_path
    else
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    end
  end

  def invite_token
    request.env['omniauth.params']['invite']
  end

end
