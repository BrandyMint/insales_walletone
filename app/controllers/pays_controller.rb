class PaysController < ApplicationController
  include PaymentHelpers

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate

  # insales doc https://wiki.insales.ru/wiki/%D0%9F%D0%BE%D0%B4%D0%BA%D0%BB%D1%8E%D1%87%D0%B5%D0%BD%D0%B8%D0%B5_%D0%B2%D0%BD%D0%B5%D1%88%D0%BD%D0%B5%D0%B3%D0%BE_%D1%81%D0%BF%D0%BE%D1%81%D0%BE%D0%B1%D0%B0_%D0%BE%D0%BF%D0%BB%D0%B0%D1%82%D1%8B_(%D0%B4%D0%BB%D1%8F_%D1%80%D0%B0%D0%B7%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D1%87%D0%B8%D0%BA%D0%BE%D0%B2_%D0%B8%D0%BD%D1%82%D0%B5%D0%B3%D1%80%D0%B0%D1%86%D0%B8%D0%B9)
  # walletone doc http://www.walletone.com/ru/merchant/documentation/
  def pay
    @account = Account.find_by(walletone_shop_id: params[:shop_id])
    if @account
      wmi_params = calculate_walletone_params(@account, params)
      walletone_uri = URI(configus.walletone_payment_url)
      walletone_uri.query = wmi_params.to_query
      redirect_to(walletone_uri.to_s)
    else
      redirect_to configus.redirect_url
    end
  end

  def walletone_result
    @account = Account.find_by(walletone_shop_id: params[:WMI_MERCHANT_ID])
    render text: 'WMI_RESULT=RETRY&WMI_DESCRIPTION=invalid signature' unless payment_valid?(@account, params)
    render text: 'WMI_RESULT=RETRY&WMI_DESCRIPTION=invalid state' unless params[:WMI_ORDER_STATE] == 'Accepted'
    insales_params = calculate_insales_params(@account, params)
    response = HTTParty.post(view_context.insales_result_url(@account, :success), body: insales_params)
    if response.code == '200'
      render text: 'WMI_RESULT=OK'
    else
      render text: 'WMI_RESULT=RETRY&WMI_DESCRIPTION=server busy'
    end
  end

  def success
    @account ||= Account.find_by(walletone_shop_id: params[:WMI_MERCHANT_ID])
    redirect_to view_context.insales_order_url(@account, params[:key])
  end

  def fail
    @account ||= Account.find_by(walletone_shop_id: params[:WMI_MERCHANT_ID])
    redirect_to view_context.insales_order_url(@account, params[:key])
  end
end
