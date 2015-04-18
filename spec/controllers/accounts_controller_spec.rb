describe AccountsController, type: :controller do
  context 'install' do
    it 'should call install for WalletoneApp' do
      allow(WalletoneApp).to receive(:install).and_return(true)

      get :install, token: 'token', shop: 'my.shop.com', insales_id: 1

      expect(response.status).to eq(200)
    end

    it 'should raise error if cant install' do
      allow(WalletoneApp).to receive(:install).and_return(false)

      expect {
        get :install, token: 'token', shop: 'my.shop.com', insales_id: 1
      }.to raise_error
    end
  end

  context 'uninstall' do
    it 'should call uninstall for WalletoneApp' do
      allow(WalletoneApp).to receive(:uninstall).and_return(true)

      get :uninstall, token: 'token'

      expect(response.status).to eq(200)
    end

    it 'should raise error if cant install' do
      allow(WalletoneApp).to receive(:uninstall).and_return(false)

      expect {
        get :uninstall, token: 'token'
      }.to raise_error
    end
  end

  context 'update' do
    let(:currency_id)        { 643 }
    let(:payment_gateway_id) { 123 }

    let(:account) { Fabricate(:account, walletone_currency: 1, payment_gateway_id: 1) }
    let(:app)     { WalletoneApp.new(account.domain, account.password) }

    before(:each) do
      app.configure_api
      app.authorization_url
      session[:app] = app
    end

    it 'updates account' do
      expect(account.walletone_currency).to eq(1)
      expect(account.payment_gateway_id).to eq(1)

      attrs = { walletone_currency: currency_id,
        payment_gateway_id: payment_gateway_id }
      put :update, account: attrs, token: app.auth_token
      account.reload

      expect(account.walletone_currency).to eq(currency_id)
      expect(account.payment_gateway_id).to eq(payment_gateway_id)
    end
  end
end
