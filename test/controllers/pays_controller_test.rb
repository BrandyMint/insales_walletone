require 'test_helper'

class PaysControllerTest < ActionController::TestCase
  include PaymentHelpers

  setup do
    @account = accounts(:my_shop)
  end

  test 'should get fail' do
    params = {
      WMI_MERCHANT_ID: @account.walletone_shop_id,
      key: 'bf3f5e24d40e5f7caa5fa9d64070b5e3'
    }
    post :fail, params
    assert_response :redirect
  end

  test 'should get success' do
    params = {
      WMI_MERCHANT_ID: @account.walletone_shop_id,
      key: 'bf3f5e24d40e5f7caa5fa9d64070b5e3'
    }
    post :success, params
    assert_response :redirect
  end

  test 'should post walletone_result' do
    account = accounts(:my_shop)
    params = {
      'key' => 'bf3f5e24d40e5f7caa5fa9d64070b5e3',
      'WMI_AUTO_ACCEPT' => '1',
      'WMI_COMMISSION_AMOUNT' => '0.00',
      'WMI_CREATE_DATE' => '2014-12-16 19:39:59',
      'WMI_CURRENCY_ID' => '643',
      'WMI_DESCRIPTION' => 'order description',
      'WMI_EXPIRED_DATE' => '2015-01-16 19:39:59',
      'WMI_FAIL_URL' => 'http://test.myinsales.ru/orders/bf3f5e24d40e5f7caa5fa9d64070b5e3',
      'WMI_LAST_NOTIFY_DATE' => '2014-12-19 13:49:52',
      'WMI_MERCHANT_ID' => account.walletone_shop_id,
      'WMI_NOTIFY_COUNT' => '75',
      'WMI_ORDER_ID' => '346936430734',
      'WMI_ORDER_STATE' => 'Accepted',
      'WMI_PAYMENT_AMOUNT' => '0.10',
      'WMI_PAYMENT_NO' => '2192673',
      'WMI_PAYMENT_TYPE' => 'SberOnlineRUB',
      'WMI_SUCCESS_URL' => 'http://test.myinsales.ru/orders/bf3f5e24d40e5f7caa5fa9d64070b5e3',
      'WMI_UPDATE_DATE' => '2014-12-16 19:43:03'
    }
    params['WMI_SIGNATURE'] = walletone_signature(params, account.walletone_password)
    stub_request(:post, "http://#{account.domain}/payments/external/#{account.payment_gateway_id}/success")
      .to_return(status: 200, body: '', headers: {})
    post :walletone_result, params
    assert_response :success
  end

  test 'should post pay' do
    account = accounts(:my_shop)
    params = {
      shop_id: account.walletone_shop_id,
      amount: 0.1,
      transaction_id: 2_197_421,
      key: '201c02c69db32b95ecf878b3172121c4',
      description: 'Заказ №9999 на сайте test.myinsales.ru',
      order_id: 4_020_290,
      phone: 9_987_654_321,
      email: 'test@example.com'
    }

    VCR.use_cassette('order') do
      post :pay, params
    end
    assert_response :redirect
  end
end
