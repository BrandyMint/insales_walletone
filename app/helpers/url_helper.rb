module UrlHelper
  def shop_settings_url
    "http://#{Settings.insales.api_host}"
  end

  def redirect_url(path_type)
    "http://#{Settings.insales.api_host}/#{path_type}"
  end

  def insales_result_url(account, path_type)
    "http://#{account.domain}/payments/external/#{account.payment_gateway_id}/#{path_type}"
  end

  def insales_order_url(account, key)
    "http://#{account.domain}/orders/#{key}"
  end

  def insales_payment_gateway_url(account)
    "http://#{account.domain}/admin2/payment_gateways/#{account.payment_gateway_id}/edit"
  end

  def insales_payment_gateways_url(account)
    "http://#{account.domain}/admin2/payment_gateways"
  end

  def shop_url(account)
    "http://#{account.domain}"
  end

  def admin_panel_url(account)
    "http://#{account.domain}/admin/home"
  end
end
