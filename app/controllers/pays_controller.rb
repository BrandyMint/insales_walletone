class PaysController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate

  #insales doc https://wiki.insales.ru/wiki/%D0%9F%D0%BE%D0%B4%D0%BA%D0%BB%D1%8E%D1%87%D0%B5%D0%BD%D0%B8%D0%B5_%D0%B2%D0%BD%D0%B5%D1%88%D0%BD%D0%B5%D0%B3%D0%BE_%D1%81%D0%BF%D0%BE%D1%81%D0%BE%D0%B1%D0%B0_%D0%BE%D0%BF%D0%BB%D0%B0%D1%82%D1%8B_(%D0%B4%D0%BB%D1%8F_%D1%80%D0%B0%D0%B7%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D1%87%D0%B8%D0%BA%D0%BE%D0%B2_%D0%B8%D0%BD%D1%82%D0%B5%D0%B3%D1%80%D0%B0%D1%86%D0%B8%D0%B9)
  #walletone doc http://www.walletone.com/ru/merchant/documentation/
  def pay
    walletone_shop_id = params[:shop_id]
    amount = params[:amount]
    transaction_id = params[:transaction_id]
    description = params[:description]
    key = params[:key]
    order_id = params[:order_id]
    phone = params[:phone]
    email = params[:email]

    @account = Account.find_by(walletone_shop_id: walletone_shop_id)
    insales_app = InsalesApi::App.new(@account.domain, @account.password)
    insales_app.configure_api

    order = InsalesApi::Order.find(order_id)
    fio = order.client.name
    client_surname, client_name = fio.split(' ')

    wmi_params = {
        WMI_MERCHANT_ID: walletone_shop_id,
        WMI_PAYMENT_AMOUNT: amount,
        WMI_CURRENCY_ID: @account.walletone_currency,
        WMI_PAYMENT_NO: transaction_id,
        WMI_DESCRIPTION: "BASE64:#{Base64.encode64(description)}",
        WMI_SUCCESS_URL: "#{configus.host}/success",
        WMI_FAIL_URL: "#{configus.host}/fail",
        WMI_RECIPIENT_LOGIN: email || phone,
        WMI_CUSTOMER_FIRSTNAME: client_name,
        WMI_CUSTOMER_LASTNAME: client_surname,
        WMI_CUSTOMER_EMAIL: email,
        amount: amount,
        transaction_id: transaction_id,
        key: key,
        order_id: order_id,
        phone: phone,
        email: email
    }

    signature = get_signature(wmi_params, @account.walletone_password)
    wmi_params[:WMI_SIGNATURE] = signature

    walletone_uri = URI(configus.walletone_payment_url)
    walletone_uri.query = wmi_params.to_query
    redirect_to walletone_uri.to_s
  end

  def wmi_result
    p '*'*100
    p params
    @account = Account.find_by(walletone_shop_id: params[:WMI_MERCHANT_ID])
    responce_signature = params.delete :WMI_SIGNATURE
    calculated_signature = get_signature(params, @account.walletone_password)
    if responce_signature == calculated_signature
      p 'ok'
      render text: 'WMI_RESULT=OK'
    else
      p 'fail'
      render text: 'WMI_RESULT=OK'
    end
  end

  def fail
    render text: 'ok'
  end

  def success
    render text: 'ok'
  end

  private

  def get_signature(params, secret)
    down_key_params = {}
    params.map{|k,v| down_key_params[k.downcase] = v}
    values = ''
    down_key_params.sort.map{|k, v| values += v.to_s}
    Digest::MD5.base64digest(values+secret)
  end

end
