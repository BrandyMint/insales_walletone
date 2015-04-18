describe WalletoneApp do
  let!(:default_account) { Fabricate(:account) }

  describe '.install' do
    it 'return true if successefuly install' do
      result = described_class.install('my.shop.com', 'token', 1)
      expect(result).to be_truthy
    end

    it 'create new account' do
      expect {
        described_class.install('my.shop.com', 'token', 1)
      }.to change(Account, :count).by(1)

      account = Account.last

      expect(account.domain).to eq('my.shop.com')
      expect(account.password).to eq(described_class.password_by_token('token'))
      expect(account.insales_id).to eq(1)
    end

    it 'return true if app already installed' do
      result = described_class.install(default_account.domain, 'token', 1)
      expect(result).to be_truthy
    end

    it 'no create new account if app already installed' do
      expect {
        described_class.install(default_account.domain, 'token', 1)
      }.to change(Account, :count).by(0)
    end
  end

  describe '.uninstall' do
    it 'destroy account' do
      result = described_class.uninstall(default_account.domain, default_account.password)
      expect(result).to be_truthy

      account = Account.find_by(domain: default_account.domain)
      expect(account).not_to be
    end

    it 'not destroy account if password incorrect' do
      result = described_class.uninstall(default_account.domain, 'bad password')
      expect(result).to be_falsy

      account = Account.find_by(domain: default_account.domain)
      expect(account).to be
    end
  end
end