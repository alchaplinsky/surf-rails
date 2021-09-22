class Api::TagsController < Api::BaseController

  def index
    tags = current_user.active_tags.by_query(params[:query]).map do |key, val|
      {
        name: key,
        count: val
      }
    end
    render json: tags
  end

end
