class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :shop_id, null: false
      t.float :amount, null: false
      t.integer :transaction_id, null: false
      t.text :description
      t.string :key, null: false
      t.integer :order_id, null: false
      t.string :phone
      t.string :email

      t.timestamps null: false
    end

    add_index :payments, :transaction_id, unique: true
  end
end
