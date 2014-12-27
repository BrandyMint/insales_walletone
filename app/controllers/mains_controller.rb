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

    delivery_variants_id =  InsalesApi::DeliveryVariant.all.map(&:id)
    delivery_variants = delivery_variants_id.inject([]) { |result, dv_id| result << { delivery_variant_id: dv_id } }

    @walletone_payment_gateway = InsalesApi::PaymentGateway.create(
        type: 'PaymentGateway::External',
        title: title,
        shop_id: @account.walletone_shop_id,
        password: @account.walletone_password,
        url: payment_url,
        description: configus.payment_gateway.description,
        payment_delivery_variants_attributes: delivery_variants
    )
    @account.update(payment_gateway_id: @walletone_payment_gateway.id) unless params[:type]
    redirect_to root_path
  end
end
