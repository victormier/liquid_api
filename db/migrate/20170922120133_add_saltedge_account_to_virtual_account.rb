class AddSaltedgeAccountToVirtualAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :virtual_accounts, :saltedge_account_id, :integer
    add_index :virtual_accounts, :saltedge_account_id, unique: true
  end
end
