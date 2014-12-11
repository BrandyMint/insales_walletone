class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authentication

  protected

  def authentication
    token = params[:token]
    domain = params[:domain]
    insales_id = params[:insales_id]

    if insales_api
      if token && insales_api.authorize(token)
        save_session insales_api
      end
      if insales_api.authorized?
        @account ||= find_account(insales_api.shop)
      end
    else
      @account ||= find_account(domain, insales_id)
      redirect_to 'http://insales.ru' and return unless @account
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
    session[:api] = Marshal::dump(api)
  end

  def load_session
    session_api = session[:api]
    Marshal::load(session_api) if session_api
  end
end
