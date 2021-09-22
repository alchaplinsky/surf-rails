class Paypal::PaymentService
  def get_order(order_id)
    request = ::PayPalCheckoutSdk::Orders::OrdersGetRequest::new(order_id)
    response = ::Paypal::Client::client::execute(request)

    return nil unless response.status_code == 200
    return nil unless correct_ammount?(response)

    {
      order_id: response.result.id,
      payer_id: response.result.payer.payer_id,
      name: "#{response.result.payer.name.given_name} #{response.result.payer.name.surname}",
      email: response.result.payer.email_address,
      country: response.result.payer.address.try(:country_code),
      status: response.result.status
    }
  end

  def correct_ammount?(response)
    response.result.purchase_units[0].amount.value == sprintf( "%0.02f", Settings.plans.premium.price)
  end
end
