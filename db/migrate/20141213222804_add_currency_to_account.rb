class AddCurrencyToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :walletone_currency, :integer
  end
end
