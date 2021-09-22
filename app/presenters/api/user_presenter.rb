class Api::UserPresenter < BasePresenter
  PROVIDERS = {
    facebook: 'Facebook',
    google_oauth2: 'Google'
  }
  attributes :id, :first_name, :last_name, :email, :avatar, :provider_name, :premium

  def avatar
    { url: object.avatar.url } if object.avatar.present?
  end

  def provider_name
    PROVIDERS[object.provider.to_sym]
  end
end
