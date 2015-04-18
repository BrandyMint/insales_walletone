class PayForm < BaseForm
  # https://wiki.insales.ru/wiki/Подключение_внешнего_способа_оплаты_(для_разработчиков_интеграций)

  attribute :shop_id
  attribute :amount
  attribute :transaction_id
  attribute :description
  attribute :key
  attribute :order_id
  
  attribute :email
  attribute :phone
end
