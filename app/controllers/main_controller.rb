class MainController < ApplicationController
  def index

  end

  def create_payment_getway
    @walletone_payment_gateway = InsalesApi::PaymentGateway.where(title: configus.payment_gateway.title).first
    unless @walletone_payment_gateway
      @walletone_payment_gateway = InsalesApi::PaymentGateway.create(
          type: 'PaymentGateway::External',
          title: configus.payment_gateway.title,
          shop_id: 'w1shopID', #TODO здесь должен быть id от мерчант аккаунта
          password: 'pass12345', #TODO здесь должена быть подпись от мерчант аккаунта
          url: configus.payment_gateway.payment_url, #путь к платежному входу
          description: configus.payment_gateway.description
      )
    end
  end


  def manual
  end

end
