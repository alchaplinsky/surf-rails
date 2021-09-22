class Oauth::BaseService

  attr_reader :avatar_url

  def find_or_create_from_oauth(auth, invite = nil)
    @auth = auth
    @invite = invite
    find || create
  end

  def create_from_params(params, invite = nil)
    @params = params
    @invite = invite
    create
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_interest
      accept_invite
    end
    @user
  end

  protected

  def find
    User.where(provider: provider, uid: uid).first
  end

  def create_interest
    @user.own_interests.create(name: 'getting_started', user_id: @user.id)
  end

  def accept_invite
    Invite.find_by_token(@invite).try(:accept!) if @invite.present?
  end

  def user_params
    @auth.present? ? auth_params : @params
  end

  def auth_params
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      provider: provider,
      uid: uid,
      api_token: Devise.friendly_token[0,20],
      password: Devise.friendly_token[0,20],
      remote_avatar_url: avatar,
      premium: false
    }
  end

  def provider
    @auth.provider
  end

  def uid
    @auth.uid.to_s
  end

  def email
    @auth.info.email
  end

  def first_name
    @auth.info.first_name
  end

  def last_name
    @auth.info.last_name
  end

  def avatar
    @avatar_url ||= @auth.info.image
  end

end
