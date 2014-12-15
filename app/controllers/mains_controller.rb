class MainsController < ApplicationController

  def index
  end

  def manual
  end

  def initialize_payment_gateway
    unless InsalesApi::PaymentGateway.all.map(&:id).include?(@account.payment_gateway_id)
      @walletone_payment_gateway = InsalesApi::PaymentGateway.create(
          type: 'PaymentGateway::External',
          title: configus.payment_gateway.title,
          shop_id: @account.walletone_shop_id,
          password: @account.walletone_password,
          url: configus.payment_gateway.payment_url,
          description: configus.payment_gateway.description
      )
      @account.update(payment_gateway_id: @walletone_payment_gateway.id)
    end
  end

end
