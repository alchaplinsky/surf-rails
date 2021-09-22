class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def after_sign_in_path_for(resource)
    dashboard_url
  end

  def after_sign_out_path_for(resource)
    request.referrer || root_path
  end

  def require_user!
    redirect_to root_url unless user_signed_in?
  end

  def user_not_authorized
    redirect_to root_url
  end

  def build_download_data
    @download = DownloadPresenter.new(request.env['HTTP_USER_AGENT']).as_json
  end

end
