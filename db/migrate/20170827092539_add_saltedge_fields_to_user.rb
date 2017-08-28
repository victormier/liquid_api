class AddSaltedgeFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :saltedge_id, :string
    add_column :users, :saltedge_custom_identifier, :string
    add_column :users, :saltedge_customer_secret, :string
  end
end
