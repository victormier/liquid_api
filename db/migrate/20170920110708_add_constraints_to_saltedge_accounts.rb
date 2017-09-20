class AddConstraintsToSaltedgeAccounts < ActiveRecord::Migration[5.1]
  def change
    change_column :saltedge_accounts, :saltedge_login_id, :integer, null: false
    remove_index :saltedge_accounts, :saltedge_login_id
    add_index :saltedge_accounts, :saltedge_login_id, unique: true
  end
end
