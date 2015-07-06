class WalletoneApp < InsalesApi::App
  class << self
    def install(shop, token, insales_id)
      domain = self.prepare_domain(shop)

      if Account.find_by(domain: domain)
        return true
      end

      account = Account.new({ domain: domain, insales_id: insales_id,
        password: self.password_by_token(token) })
      account.save
    end

    def uninstall(shop, password)
      domain = self.prepare_domain(shop)
      account = Account.find_by(domain: domain)

      return true unless account
      return false if account.password != password

      account.destroy
    end
  end
end
