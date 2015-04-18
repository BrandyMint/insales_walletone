describe PayController, type: :controller do
  let(:account) { Fabricate.build(:example_account) }
  let(:app)     { WalletoneApp.new(account.domain, account.password) }

  context '#fail' do
    it 'redirect to insales orders page' do
      post :fail, {
        WMI_MERCHANT_ID: account.walletone_shop_id,
        key: 'bf3f5e24d40e5f7caa5fa9d64070b5e3'
      }

      expect(response).to have_http_status(:redirect)
    end
  end

  context '#success' do
    it 'redirect to insales orders page' do
      post :success, {
        WMI_MERCHANT_ID: account.walletone_shop_id,
        key: 'bf3f5e24d40e5f7caa5fa9d64070b5e3'
      }

      expect(response).to have_http_status(:redirect)
    end
  end

  context '#pay' do
    before do
      stub_request(:get, "http://:pass2@myothershop.insales.ru/admin/orders/4020290.xml")
        .to_return(body: response_from_file('get/orders/4020290.xml'))

      stub_request(:post, "https://wl.walletone.com/checkout/checkout/Index")
        .to_return(headers: {'Location' => '/checkout/checkout/Index?i=344914986802&m=127830694690'})

      post :pay, {
        shop_id: account.walletone_shop_id,
        amount: 0.1,
        transaction_id: 2_197_421,
        key: '201c02c69db32b95ecf878b3172121c4',
        description: 'Заказ №9999 на сайте test.myinsales.ru',
        order_id: 4_020_290,
        phone: 9_987_654_321,
        email: 'test@example.com'
      }
    end
    
    it { expect(response).to have_http_status(:redirect) }
    it { expect(response.headers['Location']).to include('/Index?i=344914986802&m=127830694690') }
  end
end
