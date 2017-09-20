class CreateSaltedgeAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :saltedge_accounts do |t|
      t.integer :saltedge_login_id
      t.integer :user_id
      t.string :saltedge_id
      t.text :saltedge_data
      t.timestamps
    end

    add_index :saltedge_accounts, :saltedge_login_id
    add_index :saltedge_accounts, :user_id
  end
end
