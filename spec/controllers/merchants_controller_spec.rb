describe MerchantsController, type: :controller do
  let(:auth) { Settings.auth }

  context 'index' do
    it 'requires auth' do
      get :index

      expect(response).to have_http_status(401)
    end

    it 'returns http success' do
      basic_login auth.login, auth.password
      get :index

      expect(response).to have_http_status(:success)
      expect(assigns(:accounts)).to be
    end
  end

  context 'show' do
    let!(:account) { Fabricate(:account) }

    it 'requires auth' do
      get :show, id: account.id

      expect(response).to have_http_status(401)
    end

    it 'returns http success' do
      basic_login auth.login, auth.password
      get :show, id: account.id

      expect(response).to have_http_status(:success)
      expect(assigns(:account)).to be_an(Account)
      expect(assigns(:payments)).to be
    end
  end
end
