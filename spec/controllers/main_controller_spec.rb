describe MainController, type: :controller do
  let(:account) { Fabricate(:account) }
  let(:app)     { WalletoneApp.new(account.domain, account.password) }

  before(:each) do
    WalletoneApp.api_key = 'my_key' # sometimes it resets
    app.authorization_url
    save_app(app)
  end

  context 'index' do
    it 'redirects to authorize url' do
      get :index, domain: account.domain, insales_id: account.insales_id
      app = WalletoneApp.new(account.domain, account.password)

      expect(response).to redirect_to(app.authorization_url)
    end

    it 'gets index with token' do
      get :index, token: app.auth_token

      expect(response).to have_http_status(:success)
    end
  end

  context 'manual' do
    it 'gets manual' do
      get :manual, token: app.auth_token

      expect(response).to have_http_status(:success)
    end
  end

  context 'initialize_payment_gateway' do
    let(:account) do
      Fabricate(:account, domain: 'shop.dev', password: 'pswd', payment_gateway_id: 248603)
    end

    before(:each) do
      stub_request(:get, 'http://my_key:pswd@shop.dev/admin/delivery_variants.xml')
        .to_return(body: response_from_file('get/delivery_variants.xml'))

      stub_request(:post, 'http://my_key:pswd@shop.dev/admin/payment_gateways.xml')
        .to_return(body: response_from_file('post/payment_gateways.xml'))
    end

    it 'creates payment_gateway over InsalesApi' do
      get :initialize_payment_gateway, token: app.auth_token
      account.reload

      expect(account.payment_gateway_id).to eq(123)
      expect(response).to redirect_to(root_path)
    end

    it 'creates payment_gateway with custom name and type' do
      arguments = {}
      expect(InsalesApi::PaymentGateway).to receive(:create) do |args|
        arguments = args
      end

      get :initialize_payment_gateway, token: app.auth_token,
        name: 'test_name', type: 'test_type'

      expect(arguments[:title]).to eq('test_name')
      expect(arguments[:url]).to eq('http://localhost:1234/pay?q=test_type')
    end
  end
end
