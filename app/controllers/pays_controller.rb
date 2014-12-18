class PaysController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate

  # insales doc https://wiki.insales.ru/wiki/%D0%9F%D0%BE%D0%B4%D0%BA%D0%BB%D1%8E%D1%87%D0%B5%D0%BD%D0%B8%D0%B5_%D0%B2%D0%BD%D0%B5%D1%88%D0%BD%D0%B5%D0%B3%D0%BE_%D1%81%D0%BF%D0%BE%D1%81%D0%BE%D0%B1%D0%B0_%D0%BE%D0%BF%D0%BB%D0%B0%D1%82%D1%8B_(%D0%B4%D0%BB%D1%8F_%D1%80%D0%B0%D0%B7%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D1%87%D0%B8%D0%BA%D0%BE%D0%B2_%D0%B8%D0%BD%D1%82%D0%B5%D0%B3%D1%80%D0%B0%D1%86%D0%B8%D0%B9)
  # walletone doc http://www.walletone.com/ru/merchant/documentation/
  def pay
    @account = Account.find_by(walletone_shop_id: params[:shop_id])
    initialize_api(@account)
    wmi_params = calculate_walletone_params(params)
    walletone_uri = URI(configus.walletone_payment_url)
    walletone_uri.query = wmi_params.to_query
    redirect_to walletone_uri.to_s
  end

  def walletone_result
    @account = Account.find_by(walletone_shop_id: params[:WMI_MERCHANT_ID])
    initialize_api(@account)
    @payment_gateway = InsalesApi::PaymentGateway.find(@account.payment_gateway_id)
    render text: 'WMI_RESULT=RETRY&WMI_DESCRIPTION=invalid signature' unless payment_valid?(params)
    render text: 'WMI_RESULT=RETRY&WMI_DESCRIPTION=invalid state' unless params[:WMI_ORDER_STATE] == 'Accepted'
    insales_params = calculate_insales_params(params)
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

  private

  def calculate_walletone_params(params)
    client_surname, client_name = get_client_fio(params[:order_id])
    wmi_params = {
      WMI_MERCHANT_ID: params[:shop_id],
      WMI_PAYMENT_AMOUNT: params[:amount],
      WMI_CURRENCY_ID: @account.walletone_currency,
      WMI_PAYMENT_NO: params[:transaction_id],
      WMI_DESCRIPTION: "BASE64:#{Base64.encode64(params[:description])}",
      WMI_SUCCESS_URL: view_context.redirect_url(:success),
      WMI_FAIL_URL: view_context.redirect_url(:fail),
      WMI_RECIPIENT_LOGIN: params[:email] || params[:phone],
      WMI_CUSTOMER_FIRSTNAME: client_name,
      WMI_CUSTOMER_LASTNAME: client_surname,
      WMI_CUSTOMER_EMAIL: params[:email],
      key: params[:key],
    }
    initialize_api(@account)
    payment_gateway = InsalesApi::PaymentGateway.find(@account.payment_gateway_id)
    wmi_params[:WMI_SIGNATURE] = walletone_signature(wmi_params, payment_gateway.password)
    wmi_params
  end

  def calculate_insales_params(params)
    insales_params = { # порядок важен для вычисления подписи
      shop_id: params[:WMI_MERCHANT_ID],
      amount: params[:WMI_PAYMENT_AMOUNT],
      transaction_id: params[:WMI_PAYMENT_NO],
      key: params[:key],
      paid: 1
    }
    initialize_api(@account)
    insales_params[:signature] = insales_signature(insales_params, @payment_gateway.password)
    insales_params
  end

  def payment_valid?(params)
    responce_signature = params.delete(:WMI_SIGNATURE)
    calculated_signature = walletone_signature(params.except(:action, :controller), @payment_gateway.password)
    responce_signature == calculated_signature
  end

  def get_client_fio(order_id)
    order = InsalesApi::Order.find(order_id)
    fio = order.client.name
    fio.split(' ')
  end

  def initialize_api(account)
    insales_app = InsalesApi::App.new(account.domain, account.password)
    insales_app.configure_api
  end

  def insales_signature(params, password)
    values = params.merge(password: password).values.join(';')
    Digest::MD5.hexdigest(values)
  end

  def walletone_signature(params, secret)
    down_key_params = {}
    params.map { |k, v| down_key_params[k.downcase] = v }
    values = ''
    down_key_params.sort.map { |k, v| values += v.to_s }
    Digest::MD5.base64digest(values + secret)
  end
end
