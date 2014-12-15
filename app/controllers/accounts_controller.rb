class AccountsController < ApplicationController
  protect_from_forgery only: :update
  skip_before_action :authenticate, except: :update

  def install
    domain = prepare(params[:shop])
    password = params[:token]
    insales_id = params[:insales_id]

    if domain && password && insales_id
      Account.create(domain: domain, password: password, insales_id: insales_id)
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
    params.require(:account).permit(:walletone_shop_id, :walletone_password)
  end

end
