class MainsController < ApplicationController
  def index
    @insales_all_payment_gateway = InsalesApi::PaymentGateway.all
  end

  def manual
  end

  def initialize_payment_gateway
    @walletone_payment_gateway = InsalesApi::PaymentGateway.create(
        type: 'PaymentGateway::External',
        title: configus.payment_gateway.title,
        url: configus.payment_url,
        description: configus.payment_gateway.description
    )
    @account.update(payment_gateway_id: @walletone_payment_gateway.id)
    redirect_to root_path
  end
end
