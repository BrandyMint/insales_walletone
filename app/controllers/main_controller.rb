class MainController < ApplicationController
  def index
  end

  def manual
  end

  def new_payment_gateway
    @payments ||= load_payment_gateways
  end

  def initialize_payment_gateway
    form   = PaymentGatewayForm.new(params)
    result = CreatePaymentGateway.new(account, form).call

    redirect_to root_path
  end

private

  def load_payment_gateways
    YAML.load_file('lib/payment_gateways.yaml')
  end
end
