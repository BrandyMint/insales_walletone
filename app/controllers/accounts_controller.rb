class AccountsController < ApplicationController

  skip_action :authenticate

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

  protected

  def prepare(str)
    str.to_s.strip.downcase
  end

end
