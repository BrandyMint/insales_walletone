Configus.build Rails.env do
  env :production do
    app_name 'Wallet One'
    host 'insales.walletone.com'
    redirect_url 'http://insales.com'
    walletone_payment_url 'https://www.walletone.com/checkout/default.aspx'

    payment_gateway do
      payment_url 'insales.walletone.com/pay'
      title 'Название метода оплаты'
      description 'Описание'
    end

  end

  env :development, parent: :production do
    host 'localhost:3000'
    redirect_url 'http://ya.ru'

    payment_gateway do
      payment_url 'http://localhost:3000/pay'
      titile 'walletone payment getway'
      description 'самый офигительный способ оплатить свою покупку :)'
    end

  end

  env :test, parent: :development do
  end
end
