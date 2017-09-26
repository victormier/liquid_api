class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :type
      t.integer :virtual_account_id
      t.integer :related_virtual_account_id
      t.integer :saltedge_transaction_id
      t.integer :virtual_transaction_id
      t.decimal :amount
      t.datetime :made_on
      t.timestamps
    end

    add_index :transactions, :related_virtual_account_id
    add_index :transactions, :virtual_account_id
    add_index :transactions, :saltedge_transaction_id
  end
end
