class RemoveConstraintsFromSaltedgeAccounts < ActiveRecord::Migration[5.1]
  def change
    remove_index :saltedge_accounts, :saltedge_login_id
    add_index :saltedge_accounts, :saltedge_login_id
  end
end
