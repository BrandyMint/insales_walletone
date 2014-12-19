require 'test_helper'

class MainsControllerTest < ActionController::TestCase
  setup do
    @account = accounts(:my_shop)
  end

  def create_app_into_session
    @api_app = InsalesApi::App.new(@account.domain, @account.password)
    @api_app.configure_api
    @api_app.authorization_url # кривое апи :( вызов ссылки создает токен
    session[:api] = Marshal.dump(@api_app)
  end

  test 'should redirect to authorize url' do
    params = { domain: @account.domain, insales_id: @account.insales_id }
    get :index, params
    app = InsalesApi::App.new(@account.domain, @account.password)
    app.configure_api
    assert_redirected_to app.authorization_url
  end

  test 'should get index with token' do
    create_app_into_session

    params = { token: @api_app.auth_token }
    VCR.use_cassette('get_payment_gateway') do
      get :index, params
    end
    assert_response :success
  end

  test 'should get manual' do
    create_app_into_session
    params = { token: @api_app.auth_token }
    get :manual, params
    assert_response :success
  end

  test 'should create payment_gateway over InsalesApi' do
    create_app_into_session
    params = { token: @api_app.auth_token }
    VCR.use_cassette('create_payment_gateway') do
      get :initialize_payment_gateway, params
      @account.reload
      payment_gateway = InsalesApi::PaymentGateway.find(@account.payment_gateway_id)
      assert { payment_gateway }
    end
    assert_redirected_to root_path
  end
end
