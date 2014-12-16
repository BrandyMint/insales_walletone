class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate

  protected

  def authenticate
    token = params[:token]
    domain = params[:domain]
    insales_id = params[:insales_id]

    if insales_api
      if token && insales_api.authorize(token)
        save_session insales_api
      end
      if insales_api.authorized?
        insales_api.configure_api
        @account ||= find_account(insales_api.shop)
      end
    else
      @account ||= find_account(domain, insales_id)
      redirect_to(configus.redirect_url) and return unless @account
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
