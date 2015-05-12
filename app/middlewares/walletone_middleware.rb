class WalletoneMiddleware < Walletone::Middleware::Base
  include UrlHelper

  def perform(notify, env)
    account = Account.find_by(walletone_shop_id: notify[:WMI_MERCHANT_ID])
    payment = Payment.find_by(transaction_id: notify[:WMI_PAYMENT_NO])

    Rails.logger.info "Walletone middleware"
    Rails.logger.info "  notify: #{notify}"

    unless payment
      raise 'undefined payment'
    end

    unless notify.valid?(account.walletone_password)
      raise 'invalid signature'
    end

    unless notify[:WMI_ORDER_STATE] == 'Accepted'
      raise 'invalid state'
    end

    payment.update!(status: 'paid')
    insales_url = insales_result_url(account, :success)
    insales_params = calculate_insales_params(account, notify)
    response = Faraday.post(insales_url, insales_params)

    Rails.logger.error "  insales_url: #{insales_url}"
    Rails.logger.error "  insales_params: #{insales_params}"

    if response.status == 200
      'ok'
    else
      Rails.logger.error "  server busy"
      Rails.logger.error "  status: #{response.status}"
      Rails.logger.error "  body: #{response.body}"
      raise 'server busy'
    end
  end

private

  def calculate_insales_params(account, notify)
    insales_params = {
      # порядок важен для вычисления подписи
      shop_id:        notify[:WMI_MERCHANT_ID],
      amount:         notify[:WMI_PAYMENT_AMOUNT],
      transaction_id: notify[:WMI_PAYMENT_NO],
      key:            notify[:key],
      paid:           1
    }
    insales_params[:signature] = insales_signature(insales_params, account.walletone_password)
    insales_params
  end

  def insales_signature(params, password)
    values = params.merge(password: password).values.join(';')
    Digest::MD5.hexdigest(values)
  end
end
