Fabricator(:account) do
  insales_id { rand(100) }
  domain     { FFaker::Internet.domain_name }
  password   { FFaker::Internet.password }

  walletone_shop_id  { rand(100) }
  walletone_password { FFaker::Internet.password }
  walletone_currency { 643 }
  payment_gateway_id { 3456 }
end

Fabricator(:example_account, from: :account) do
  insales_id 123456
  domain     'myothershop.insales.ru'
  password   'pass2'

  walletone_shop_id  { 234235 }
  walletone_password { 'passwd' }
  walletone_currency { 643 }
  payment_gateway_id { 3456 }
end
