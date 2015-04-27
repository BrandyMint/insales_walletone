class MerchantsController < ApplicationController
  skip_before_action :authenticate, :configure_api
  before_action :authenticate_http_basic
  layout 'merchants'

  def index
    @accounts = Account.all
  end

  def show
    @account = Account.find(params[:id])
    @payments = @account.payments
  end

private

  def authenticate_http_basic
    authenticate_or_request_with_http_basic do |username, password|
      username == Settings.auth.login.to_s &&
        password == Settings.auth.password.to_s
    end
  end
end
