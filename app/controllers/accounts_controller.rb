class AccountsController < ApplicationController
  skip_before_action :authenticate, except: [:update]
  skip_before_action :configure_api, except: [:autologin]

  def autologin
    if current_app && auth_token == params[:token]
      redirect_to location || root_path
    else
      redirect_to Settings.redirect_url
    end
  end

  def install
    status = WalletoneApp.install(params[:shop],
      params[:token], params[:insales_id])
    raise 'Fail to install' unless status

    head :ok
  end

  def uninstall
    status = WalletoneApp.uninstall(params[:shop], params[:token])
    raise 'Fail to uninstall' unless status

    head :ok
  end

  def update
    account.update(account_params)
    redirect_to root_path
  end

private

  def auth_token
    InsalesApi::Password.create(current_app.password, current_app.salt)
  end

  def account_params
    params.require(:account).permit(:payment_gateway_id,
      :walletone_currency, :walletone_shop_id, :walletone_password)
  end
end
