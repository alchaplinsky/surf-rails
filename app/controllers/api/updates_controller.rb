class Api::UpdatesController < Api::BaseController

  skip_before_action :require_user

  def show
    service = DesktopUpdateService.new(params[:os], params[:arch])
    if service.update_available?(params[:version])
      render json: { url: service.update_url }
    else
      head :no_content
    end
  end

  def testing
    service = DesktopUpdateService.new(params[:os], params[:arch], 'test')
    if service.update_available?(params[:version])
      render json: { url: service.update_url }
    else
      head :no_content
    end
  end

end
