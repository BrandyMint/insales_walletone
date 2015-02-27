Configus.build Rails.env do
  env :production do
    host -> { ENV['INSALES_API_HOST'] }
    app_name 'Wallet One'
    redirect_url 'http://insales.com'
    # старый платежный шлюз
    walletone_payment_url 'https://www.walletone.com/checkout/default.aspx'
    # новый платежный шлюз, пока работает с ошибками
    # walletone_payment_url 'https://wl.walletone.com/checkout/checkout/Index'
    payment_url -> { "http://#{host}/pay" }

    payment_gateway do
      title 'Оплата с помощью W1 Единая Касса'
      description 'Описание'
    end
  end

  env :development, parent: :production do
    redirect_url 'http://ya.ru'

    payment_gateway do
      title 'walletone payment gateway'
      description 'самый офигительный способ оплатить свою покупку :)'
    end
  end

  env :test, parent: :development do
  end
end
