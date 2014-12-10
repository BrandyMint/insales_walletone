class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :domain
      t.string :password
      t.integer :insales_id

      t.timestamps
    end
    add_index :accounts, [:domain], unique: true
  end
end
