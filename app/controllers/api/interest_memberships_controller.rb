class Api::InterestMembershipsController < Api::BaseController

  before_action :find_user, only: :create
  before_action :find_interest, only: [:index, :create]

  def index
    render json: Api::InterestMembershipPresenter.map(@interest.interest_memberships)
  end

  def create
    @membership = InterestMembership.new({
      user_id: @user.id,
      interest_id: @interest.id,
      role: 'member'
    })
    if @membership.save
      #NotificationBroadcastJob.perform_now @membership, current_user, :create
      render json: Api::InterestMembershipPresenter.new(@membership)
    else
      render_error Api::Errors::ValidationPresenter.new(@membership.errors.messages)
    end
  end

  def destroy
    @membership = current_user.managed_memberships.where(id: params[:id]).first
    @membership = current_user.interest_memberships.find params[:id] if @membership.blank?
    @membership.destroy
    #NotificationBroadcastJob.perform_now @membership, current_user, :destroy
    render json: Api::InterestMembershipPresenter.new(@membership)
  end

  private

  def find_user
    @user = User.find params[:user_id]
  end

  def find_interest
    @interest = current_user.own_interests.find(params[:interest_id])
  end

end
