class AddWalletoneShopIdAndWalletonePasswordToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :walletone_shop_id, :string
    add_column :accounts, :walletone_password, :string
  end
end
