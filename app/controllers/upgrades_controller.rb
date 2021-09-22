class UpgradesController < ApplicationController
  layout 'landing'

  skip_before_action :verify_authenticity_token, only: :create

  def show
  end

  def create
    if order = Paypal::PaymentService::new::get_order(params[:order_id])
      current_user.update_attributes(premium: true)
      upgrade = current_user.upgrades.build(order)
      upgrade.save
      render json: {}
    else
      render status: :bad_request, json: {message: 'Could not verify payment'}
    end
  end
end
