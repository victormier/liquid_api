class AddSelectedToSaltedgeAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :saltedge_accounts, :selected, :boolean, default: false
  end
end
