class CreateVirtualAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :virtual_accounts do |t|
      t.integer :user_id, null: false
      t.string :name
      t.decimal :balance, default: 0
      t.string :currency_code
      t.timestamps
    end

    add_index :virtual_accounts, :user_id
  end
end
