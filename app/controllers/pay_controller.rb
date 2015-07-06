class PayController < ApplicationController
  include UrlHelper
  skip_before_action :authenticate, :configure_api
  skip_before_action :verify_authenticity_token

  def pay
    account = Account.find_by(walletone_shop_id: params[:shop_id])
    form    = PaymentForm.new(params)
    payment = Payment.create!(form.to_h)
    result  = CreateWalletonePayment.new(account, form).call

    redirect_to result.location
  rescue Exception => e
    logger.error "Pay error #{e.inspect}"
    redirect_to Settings.redirect_url
  end

  def success
    account = Account.find_by(walletone_shop_id: params[:WMI_MERCHANT_ID])
    redirect_to insales_order_url(account, params[:key])
  end

  def fail
    account = Account.find_by(walletone_shop_id: params[:WMI_MERCHANT_ID])
    redirect_to insales_order_url(account, params[:key])
  end
end
