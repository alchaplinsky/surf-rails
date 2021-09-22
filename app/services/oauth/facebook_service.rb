class Oauth::FacebookService < Oauth::BaseService

  protected

  def first_name
    @auth.info.name.split(' ').first
  end

  def last_name
    @auth.info.name.split(' ').last
  end

  def avatar
    @avatar_url ||= define_avatar
  end

  def define_avatar
    if @auth['info']['image'].blank?
      Settings.default_avatar
    else
      @auth['info']['image'].gsub('http://','https://')
    end
  end

end
