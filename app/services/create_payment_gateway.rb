class CreatePaymentGateway < BaseService
  def initialize(account, form)
    @account = account
    @form = form
  end
  
  def action
    payment_gateway = create_payment_gateway
    
    unless @form.type
      @account.update(payment_gateway_id: payment_gateway.id)
    end
  end

protected

  def create_payment_gateway
    InsalesApi::PaymentGateway.create({
      type: 'PaymentGateway::External',
      title: title,
      shop_id: @account.walletone_shop_id,
      password: @account.walletone_password,
      url: payment_url,
      description: Settings.payment_gateway.description,
      payment_delivery_variants_attributes: fetch_delivery_variants
    })
  end

  def fetch_delivery_variants
    variants_id = InsalesApi::DeliveryVariant.all.map(&:id)
    variants_id.inject([]) do |result, variant_id|
      result << { delivery_variant_id: variant_id }
    end
  end

private

  def title
    @form.name || Settings.payment_gateway.title
  end

  def payment_url
    url = "http://#{Settings.insales.api_host}/pay"
    url += "?q=#{@form.type}" if @form.type
    url
  end
end
