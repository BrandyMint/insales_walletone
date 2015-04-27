Fabricator(:payment) do
  shop_id         { rand(100) }
  transaction_id  { rand(100) }
  order_id        { rand(100) }
  amount          { 500 }
  description     { FFaker::Lorem.words.join(' ') }
  key             { SecureRandom.hex(32) }
  phone           { FFaker::PhoneNumber.phone_number }
  email           { FFaker::Internet.email }
end
