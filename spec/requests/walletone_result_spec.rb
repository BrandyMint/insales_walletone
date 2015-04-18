describe 'POST /walletone_result', type: :request do
  let(:merchant_id) { 123456 }
  let!(:account) do
    Fabricate(:account, walletone_shop_id: merchant_id,
      walletone_password: 'passwd')
  end
  let(:valid_params) do
    {
      'KEY'                   => 'bf3f5e24d40e5f7caa5fa9d64070b5e3',
      'WMI_AUTO_ACCEPT'       => '1',
      'WMI_COMMISSION_AMOUNT' => '0.00',
      'WMI_CREATE_DATE'       => '2014-12-16 19:39:59',
      'WMI_CURRENCY_ID'       => '643',
      'WMI_DESCRIPTION'       => 'order description',
      'WMI_EXPIRED_DATE'      => '2015-01-16 19:39:59',
      'WMI_FAIL_URL'          => 'http://test.myinsales.ru/orders/bf3f5e24d40e5f7caa5fa9d64070b5e3',
      'WMI_LAST_NOTIFY_DATE'  => '2014-12-19 13:49:52',
      'WMI_MERCHANT_ID'       => merchant_id,
      'WMI_NOTIFY_COUNT'      => '75',
      'WMI_ORDER_ID'          => '346936430734',
      'WMI_ORDER_STATE'       => 'Accepted',
      'WMI_PAYMENT_AMOUNT'    => '0.10',
      'WMI_PAYMENT_NO'        => '2192673',
      'WMI_PAYMENT_TYPE'      => 'SberOnlineRUB',
      'WMI_SUCCESS_URL'       => 'http://test.myinsales.ru/orders/bf3f5e24d40e5f7caa5fa9d64070b5e3',
      'WMI_UPDATE_DATE'       => '2014-12-16 19:43:03',
      'WMI_SIGNATURE'         => 'zm0aYOafxeSyswvF9Hd5vg=='
    }
  end

  context 'when server busy' do
    before do
      stub_request(:post, "http://#{account.domain}/payments/external/#{account.payment_gateway_id}/success")
        .to_return(status: 500, body: '', headers: {})

      post '/walletone_result', valid_params
    end

    it { expect(response.body).to include('WMI_RESULT=RETRY') }
    it { expect(response.body).to include('WMI_DESCRIPTION=server busy') }
  end

  context 'when server works' do
    before do
      stub_request(:post, "http://#{account.domain}/payments/external/#{account.payment_gateway_id}/success")
        .to_return(status: 200, body: '', headers: {})
    end

    it 'accepts with valid params' do
      post '/walletone_result', valid_params

      expect(response.body).to include('WMI_RESULT=OK')
    end

    it 'error with wrong sign' do
      params = valid_params
      params['WMI_SIGNATURE'] = 'wrong_sign'

      post '/walletone_result', params

      expect(response.body).to include('WMI_RESULT=RETRY')
      expect(response.body).to include('WMI_DESCRIPTION=invalid signature')
    end
  end
end
