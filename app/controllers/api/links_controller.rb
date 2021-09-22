class Api::LinksController < Api::BaseController

  def parse
    service = Submission::RelationService.new(params[:url], {})
    render json: service.attributes
  end

end
