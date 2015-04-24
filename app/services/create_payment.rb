class CreatePayment < BaseService
  include UrlHelper
  attr_reader :location

  def initialize(account, form)
    @account = account
    @form = form
  end
  
  def action
    Walletone::Payment.encode_description = true

    raise AccountNotFoundError unless @account

    Payment.create(@form.to_h)

    payment = create_payment
    payment.sign!(@account.walletone_password, :md5)

    @location = send_request_for_location(payment)
  end

protected

  def send_request_for_location(payment)
    uri = URI(payment.form.checkout_url)
    response = HTTParty.post(uri, body: payment_to_body(payment))
    "#{uri.scheme}://#{uri.host}#{response.headers['Location']}"
  end

  def create_payment
    Walletone::Payment.new({
      WMI_MERCHANT_ID:     @account.walletone_shop_id,
      WMI_PAYMENT_AMOUNT:  @form.amount,
      WMI_CURRENCY_ID:     @account.walletone_currency,
      WMI_PAYMENT_NO:      @form.transaction_id,
      WMI_DESCRIPTION:     @form.description,
      WMI_SUCCESS_URL:     redirect_url(:success),
      WMI_FAIL_URL:        redirect_url(:fail),
      WMI_RECIPIENT_LOGIN: @form.email || @form.phone,
      WMI_CUSTOMER_EMAIL:  @form.email,
      KEY:                 @form.key
    })
  end

private

  def payment_to_body(payment)
    Hash[payment.as_list].to_query
  end
end
