class Account < ActiveRecord::Base
  validates :domain, presence: true
  validates :insales_id, presence: true
  validates :password, presence: true
end
