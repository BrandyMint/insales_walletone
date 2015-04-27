class Account < ActiveRecord::Base
  validates :domain, presence: true
  validates :insales_id, presence: true
  validates :password, presence: true

  has_many :payments, primary_key: :walletone_shop_id,
    foreign_key: :shop_id
end
