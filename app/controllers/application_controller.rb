class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate, :configure_api

protected

  def authenticate
    logout if enter_from_different_shop?

    if current_app && (current_app.authorized? || current_app.authorize(params[:token]))
      @account = Account.find_by(domain: current_app.shop)
      return if @account
    end

    if account_by_params
      init_authorization
    else
      redirect_to Settings.redirect_url
    end
  end

  def logout
    reset_session
  end

  def configure_api
    current_app.configure_api
  end

  def init_authorization
    app = WalletoneApp.new(account.domain, account.password)
    save_app(app)

    redirect_to current_app.authorization_url
  end

  def enter_from_different_shop?
    current_app && !params[:shop].blank? && params[:shop] != current_app.shop
  end

  def account_by_params
    @account ||= if params[:insales_id]
      Account.find_by(insales_id: params[:insales_id])
    else
      Account.find_by(domain: params[:shop])
    end
  end

  def account
    @account
  end

  def current_app
    session[:app]
  end

  def save_app(app)
    session[:app] = Marshal.dump(app)
  end
end
