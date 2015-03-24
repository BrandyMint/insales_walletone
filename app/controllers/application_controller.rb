class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate

  # https://wiki.insales.ru/wiki/%D0%9A%D0%B0%D0%BA_%D0%B8%D0%BD%D1%82%D0%B5%D0%B3%D1%80%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D1%82%D1%8C%D1%81%D1%8F_%D1%81_InSales
  def authenticate
    token = params[:token]
    domain = params[:shop]
    insales_id = params[:insales_id]

    if insales_api
      if insales_api.authorized? || token && insales_api.authorize(token)
        save_session insales_api
        insales_api.configure_api
        @account ||= find_account(insales_api.shop)
      else
        reset_session
        redirect_to configus.redirect_url
      end
    else
      @account ||= find_account(domain, insales_id)
      unless @account
        reset_session
        redirect_to configus.redirect_url
        return
      end
      initialize_api(@account)
    end
  end

  def initialize_api(account)
    insales_api = InsalesApi::App.new(account.domain, account.password)
    insales_api.configure_api

    authorize_url = insales_api.authorization_url
    save_session insales_api
    redirect_to authorize_url
  end

  def find_account(domain, insales_id = nil)
    if insales_id
      Account.find_by(domain: domain, insales_id: insales_id)
    else
      Account.find_by(domain: domain)
    end
  end

  def insales_api
    @insales_api ||= load_session
  end

  def save_session(api)
    session[:api] = Marshal.dump(api)
  end

  def load_session
    Marshal.load(session[:api]) if session[:api]
  end
end
