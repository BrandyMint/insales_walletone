class AccountsController < ApplicationController
  protect_from_forgery only: :update
  skip_before_action :authenticate, except: :update

  # https://wiki.insales.ru/wiki/%D0%9A%D0%B0%D0%BA_%D0%B8%D0%BD%D1%82%D0%B5%D0%B3%D1%80%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D1%82%D1%8C%D1%81%D1%8F_%D1%81_InSales
  def install
    domain = prepare(params[:shop])
    token = params[:token]
    insales_id = params[:insales_id]
    password = params[:password]

    if domain && token && insales_id
      password ||= Digest::MD5.hexdigest(token + InsalesApi::App.api_secret)
      # по умолчанию аккаунт создается с валютой - рубль
      Account.create(domain: domain, password: password, insales_id: insales_id, walletone_currency: 643)
      render nothing: true, status: :ok, content_type: 'text/html'
    else
      render nothing: true, status: 422, content_type: 'text/html'
    end
  end

  def uninstall
    domain = prepare(params[:shop])
    password = params[:token]

    if domain && password
      account = Account.find_by(domain: domain)
      account.destroy if account && account.password == password
      render nothing: true, status: :ok, content_type: 'text/html'
    else
      render nothing: true, status: 422, content_type: 'text/html'
    end
  end

  def update
    @account.update(account_params)
    redirect_to root_path
  end

  private

  def prepare(str)
    str.to_s.strip.downcase
  end

  def account_params
    params.require(:account).permit(:payment_gateway_id, :walletone_currency, :walletone_shop_id, :walletone_password)
  end
end
