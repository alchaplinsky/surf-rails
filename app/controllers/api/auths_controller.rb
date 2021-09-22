class Api::AuthsController < Api::BaseController

  skip_before_action :require_user

  def show
    if user = Oauth::AuthService.new(params).authenticate
      if user.persisted?
        render json: { api_token: user.api_token }
      else
        render_error user.errors
      end
    else
      user_not_authorized
    end
  end

end
