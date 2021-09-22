class Api::InterestsController < Api::BaseController

  before_action :find_interest, only: [:show, :update, :destroy]

  def index
    @interests = current_user.interests.preload(:submissions, :interest_memberships).order(:name)
    render json: Api::Interests::ExtendedPresenter.map(@interests, current_user: current_user)
  end

  def show
    render json: Api::Interests::ExtendedPresenter.new(@interest, current_user: current_user)
  end

  def create
    @interest = Interest.new interest_params
    if @interest.valid? and current_user.own_interests << @interest
      render json: Api::Interests::ExtendedPresenter.new(@interest, current_user: current_user)
    else
      render_error Api::Errors::ValidationPresenter.new(@interest.errors.messages)
    end
  end

  def update
    if @interest.update_attributes interest_params
      render json: Api::Interests::ExtendedPresenter.new(@interest, current_user: current_user)
    else
      render_error Api::Errors::ValidationPresenter.new(@interest.errors.messages)
    end
  end

  def destroy
    @interest.destroy
    render json: Api::Interests::SimplePresenter.new(@interest, current_user: current_user)
  end

private

  def find_interest
    @interest = current_user.interests.find(params[:id])
  end

  def interest_params
    params.require(:interest).permit(:name).merge(user_id: current_user.id)
  end
end
