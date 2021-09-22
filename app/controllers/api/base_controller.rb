class Api::BaseController < ActionController::API
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  API_VERSIONS = [1.0, 1.1, 1.2].freeze

  before_action :define_api_version
  before_action :validate_api_version
  before_action :require_user

  attr_reader :api_version

  protected

  def define_api_version
    if params[:api_version].present?
      if params[:api_version] == 'v1'
        @api_version = 1.0
      else
        @api_version = params[:api_version].to_f
      end
    else
      @api_version = 1.0
    end
  end

  def validate_api_version
    render_error({
      type: 'bad_request',
      message: 'Invalid API version'
    }) unless API_VERSIONS.include?(api_version)
  end

  def require_user
    render_error(authentication_error, :unauthorized) unless current_user
  end

  def current_user
    user = super
    return user if user.present?
    if token_header.present?
      @current_user ||= User.find_by_api_token token_header
      update_user_meta if @current_user
    end
    @current_user
  end

  def render_error(error, status = :bad_request)
    render status: status, json: error
  end

  def authentication_error
    { type: 'authentication_error', message: 'Invalid token' }
  end

  def user_not_authorized
    render_error({
      type: 'authorization_error',
      message: 'You are not authorized to perform this action'
    }, :unauthorized)
  end

  def update_user_meta
    if @current_user.app_connected_at.blank?
      @current_user.update_attributes(
        app_connected_at: Time.now,
        platform: platform_header
      )
    else
      @current_user.update_attributes(platform: platform_header)
    end
  end

  def token_header
    request.headers['X-Token']
  end

  def platform_header
    request.headers['X-Platform']
  end

end
