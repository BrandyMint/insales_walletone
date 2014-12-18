module CustomUrlHelpers
  def redirect_url(path_type)
    "http://#{configus.host}/#{path_type}"
  end

  def insales_result_url(account, path_type)
    "http://#{account.domain}/payments/external/#{account.payment_gateway_id}/#{path_type}"
  end

  def insales_order_url(account, key)
    "http://#{account.domain}/orders/#{key}"
  end

  def insales_payment_gateway_edit_url(account)
    "http://#{account.domain}/admin2/payment_gateways/#{account.payment_gateway_id}/edit"
  end
end
