class PayController < ApplicationController
  include UrlHelper
  skip_before_action :authenticate, :configure_api

  def pay
    account = Account.find_by(walletone_shop_id: params[:shop_id])
    form    = PaymentForm.new(params)
    result  = CreatePayment.new(account, form).call

    if result.success?
      redirect_to result.location
    else
      redirect_to Settings.redirect_url
    end
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
