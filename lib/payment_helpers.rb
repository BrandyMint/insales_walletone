module PaymentHelpers
  def calculate_walletone_params(account, params)
    client_surname, client_name = get_client_fio(account, params[:order_id])
    wmi_params = {
      WMI_MERCHANT_ID: params[:shop_id],
      WMI_PAYMENT_AMOUNT: params[:amount],
      WMI_CURRENCY_ID: account.walletone_currency,
      WMI_PAYMENT_NO: params[:transaction_id],
      WMI_DESCRIPTION: "BASE64:#{Base64.encode64(params[:description])}",
      WMI_SUCCESS_URL: view_context.redirect_url(:success),
      WMI_FAIL_URL: view_context.redirect_url(:fail),
      WMI_RECIPIENT_LOGIN: params[:email] || params[:phone],
      WMI_CUSTOMER_EMAIL: params[:email],
      key: params[:key]
    }

    wmi_params[:WMI_CUSTOMER_FIRSTNAME] = "BASE64:#{Base64.encode64(client_name)}" if client_name
    wmi_params[:WMI_CUSTOMER_LASTNAME] = "BASE64:#{Base64.encode64(client_surname)}" if client_surname
    wmi_params[:WMI_PTENABLED] = params[:q] if params[:q]

    wmi_params[:WMI_SIGNATURE] = walletone_signature(wmi_params, account.walletone_password)
    wmi_params
  end

  def calculate_insales_params(account, params)
    insales_params = {
      # порядок важен для вычисления подписи
      shop_id: params[:WMI_MERCHANT_ID],
      amount: params[:WMI_PAYMENT_AMOUNT],
      transaction_id: params[:WMI_PAYMENT_NO],
      key: params[:key],
      paid: 1
    }
    insales_params[:signature] = insales_signature(insales_params, account.walletone_password)
    insales_params
  end

  def payment_valid?(account, params)
    responce_signature = params.delete(:WMI_SIGNATURE)
    calculated_signature = walletone_signature(params.except(:action, :controller), account.walletone_password)
    responce_signature == calculated_signature
  end

  def get_client_fio(account, order_id)
    insales_api = InsalesApi::App.new(account.domain, account.password)
    insales_api.configure_api
    order = InsalesApi::Order.find(order_id)
    fio = order.client.name
    fio.split(' ')
  end

  def insales_signature(params, password)
    values = params.merge(password: password).values.join(';')
    Digest::MD5.hexdigest(values)
  end

  def walletone_signature(params, secret)
    down_key_params = {}
    params.map { |k, v| down_key_params[k.downcase] = v }
    values = ''
    down_key_params.sort.map { |_k, v| values += v.to_s }
    Digest::MD5.base64digest(values + secret)
  end
end
