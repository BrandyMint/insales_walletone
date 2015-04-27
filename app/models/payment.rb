class Payment < ActiveRecord::Base
  validates :shop_id, :amount, :transaction_id,
    :key, :order_id, presence: true

  enum status: { created: 0, paid: 3 }
end
