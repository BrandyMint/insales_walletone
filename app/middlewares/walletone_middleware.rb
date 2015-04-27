class WalletoneMiddleware < Walletone::Middleware::Base
  include UrlHelper

  def perform(notify, env)
    account = Account.find_by(walletone_shop_id: notify[:WMI_MERCHANT_ID])
    payment = Payment.find_by(transaction_id: notify[:WMI_PAYMENT_NO])

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
    insales_params = calculate_insales_params(account, notify)
    response = HTTParty.post(insales_result_url(account, :success), body: insales_params)

    if response.code == 200
      'ok'
    else
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
