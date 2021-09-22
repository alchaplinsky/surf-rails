class Oauth::AuthService

  PROVIDERS = %w(facebook google_oauth2)

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def authenticate
    return false unless validate_params
    if data = load_user_data
      oauth_service.new.find_or_create_from_oauth(data)
    else
      false
    end
  end

  private

  def load_user_data
    response = HTTParty.get(user_info_url)
    if response.code == 200
      build_data(response)
    else
      nil
    end
  end

  def user_info_url
    case params[:provider]
    when 'facebook'
      "https://graph.facebook.com/v2.11/#{params[:user_id]}?fields=name,email&access_token=#{params[:token]}"
    when 'google_oauth2'
      "https://www.googleapis.com/oauth2/v1/userinfo?access_token=#{params[:token]}"
    end
  end

  def oauth_service
    case params[:provider]
    when 'facebook'
      Oauth::FacebookService
    when 'google_oauth2'
      Oauth::GoogleService
    end
  end

  def build_data(response)
    user = JSON.load(response.body)
    OpenStruct.new(
      {
        provider: params[:provider],
        uid: params[:user_id],
        info: OpenStruct.new(build_info(user))
      }
    )
  end

  def build_info(user)
    case params[:provider]
    when 'facebook'
      build_from_facebook_data(user)
    when 'google_oauth2'
      build_from_google_data(user)
    end
  end

  def build_from_facebook_data(user)
    {
      email: user['email'],
      name: user['name'],
      image: "https://graph.facebook.com/v2.11/#{params[:user_id]}/picture"
    }
  end

  def build_from_google_data(user)
    {
      email: user['email'],
      first_name: user['given_name'],
      last_name: user['family_name'],
      image: user['picture']
    }
  end

  def validate_params
    params_present? and provider_valid?
  end

  def params_present?
    params[:provider].present? and params[:token].present? and params[:user_id].present?
  end

  def provider_valid?
    PROVIDERS.include?(params[:provider])
  end

end
