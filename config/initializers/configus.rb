Configus.build Rails.env do
  env :production do
    host ENV['INSALES_API_HOST']
    app_name 'Wallet One'
    redirect_url 'http://insales.com'
    walletone_payment_url 'https://www.walletone.com/checkout/default.aspx'

    payment_gateway do
      payment_url -> { "http://#{host}/pay" }
      title 'Название метода оплаты'
      description 'Описание'
    end
  end

  env :development, parent: :production do
    redirect_url 'http://ya.ru'

    payment_gateway do
      titile 'walletone payment getway'
      description 'самый офигительный способ оплатить свою покупку :)'
    end
  end

  env :test, parent: :development do
  end
end
