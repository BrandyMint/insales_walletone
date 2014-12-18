module MainHelper
  def payment_gateway_inside_insales?(account)
    InsalesApi::PaymentGateway.all.map(&:id).include?(account.payment_gateway_id)
  end

  def get_payment_gateway_title(payment_gateway_id)
    InsalesApi::PaymentGateway.find(payment_gateway_id).title
  end
end
