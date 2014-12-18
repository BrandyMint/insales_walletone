Configus.build Rails.env do
  env :production do
    host -> { ENV['INSALES_API_HOST'] }
    app_name 'Wallet One'
    redirect_url 'http://insales.com'
    walletone_payment_url 'https://www.walletone.com/checkout/default.aspx'
    payment_url -> { "http://#{host}/pay" }

    payment_gateway do
      title 'Оплата с попощью Единого Кошелька walletone'
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
