class AddSuccessAndFailUrlToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :success_url, :string
    add_column :accounts, :fail_url, :string
  end
end
