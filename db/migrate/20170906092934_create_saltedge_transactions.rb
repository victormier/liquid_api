class CreateSaltedgeTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :saltedge_transactions do |t|
      t.integer :saltedge_account_id
      t.string :saltedge_id
      t.string :status
      t.date :made_on
      t.decimal :amount
      t.string :currency_code
      t.string :category
      t.text :saltedge_data
      t.datetime :saltedge_created_at
    end
  end
end
