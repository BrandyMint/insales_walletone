require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  def create_app_into_session
    account = accounts(:my_shop)
    @api_app = InsalesApi::App.new(account.domain, account.password)
    @api_app.configure_api
    @api_app.authorization_url # кривое апи :( вызов ссылки создает токен
    session[:api] = Marshal.dump(@api_app)
    @api_app
  end

  test 'should get install' do
    attrs = {
      shop: 'my-test-shop.insales.com',
      insales_id: 12_345,
      token: 'a384b6463fc216a5f8ecb6670f86456a'
    }
    get :install, attrs

    account = Account.find_by(insales_id: attrs[:insales_id])
    assert { account }
    assert_response :success
  end

  test 'should get uninstall' do
    account = accounts(:my_shop)
    get :uninstall, shop: account.domain, token: account.password

    account = Account.find_by(insales_id: account.insales_id)
    assert { !account }
    assert_response :success
  end

  test 'should put update' do
    create_app_into_session
    attrs =  { walletone_currency: 123, payment_gateway_id: 123_456 }
    post :update, account: attrs, token: @api_app.auth_token
    account = Account.find_by(walletone_currency: attrs[:walletone_currency], payment_gateway_id: attrs[:payment_gateway_id])
    assert { account }
    assert_redirected_to root_path
  end
end
