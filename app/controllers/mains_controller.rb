class MainsController < ApplicationController
  def index
    @insales_all_payment_gateway = InsalesApi::PaymentGateway.all
  end

  def manual
  end

  def new_payment_gateway
    @payments ||= YAML.load_file('lib/payment.yaml')

  end

  def initialize_payment_gateway
    title = params[:name] || configus.payment_gateway.title
    payment_url = configus.payment_url
    payment_url += "?q=#{params[:type]}" if params[:type]
    @walletone_payment_gateway = InsalesApi::PaymentGateway.create(
        type: 'PaymentGateway::External',
        title: title,
        shop_id: @account.walletone_shop_id,
        password: @account.walletone_password,
        url: payment_url,
        description: configus.payment_gateway.description
    )
    @account.update(payment_gateway_id: @walletone_payment_gateway.id)
    redirect_to root_path
  end
end
