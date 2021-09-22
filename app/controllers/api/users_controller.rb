class Api::UsersController < Api::BaseController

  before_action :find_user, only: :show

  def index
    @users = UsersFilteringService.new(params).users
    if @users.present?
      render json: Api::UserPresenter.map(@users)
    else
      render json: []
    end
  end

  def show
    render json: Api::UserPresenter.new(@user)
  end

  protected

  def find_user
    if params_user_id == 'me'
      @user = current_user
    else
      render_error({type: 'not_found', message: "Couldn't find User"}, 404)
    end
  end

  def params_user_id
    params[:id]
  end

end
