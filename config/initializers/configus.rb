Configus.build Rails.env do
  env :production do
    app_name 'Wallet One'
    host 'http://insales.walletone.com'
    redirect_url 'http://insales.com'
    walletone_payment_url 'https://www.walletone.com/checkout/default.aspx'

    payment_gateway do
      payment_url -> { "#{host}/pay" }
      title 'Название метода оплаты'
      description 'Описание'
    end
  end

  env :development, parent: :production do
    host 'http://localhost:3000'
    redirect_url 'http://ya.ru'

    payment_gateway do
      titile 'walletone payment getway'
      description 'самый офигительный способ оплатить свою покупку :)'
    end
  end

  env :test, parent: :development do
  end
end
