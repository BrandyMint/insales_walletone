Configus.build Rails.env do
  env :production do
    app_name 'Wallet One'
  end

  env :development, parent: :production do
  end

  env :test, parent: :development do
  end
end
