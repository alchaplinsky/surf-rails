class Oauth::GoogleService < Oauth::BaseService

  protected

  def first_name
    @auth.info.first_name
  end

  def last_name
    @auth.info.last_name
  end

  def avatar
    @avatar_url ||= define_avatar
  end

  def define_avatar
    if @auth.info.image.blank?
      Settings.default_avatar
    else
      @auth.info.image.split('?')[0]
    end
  end

end
