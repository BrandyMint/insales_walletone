class AddPaymentGatewayIdToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :payment_gateway_id, :integer
  end
end
