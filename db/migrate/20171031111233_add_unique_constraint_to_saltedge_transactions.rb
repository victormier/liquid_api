class AddUniqueConstraintToSaltedgeTransactions < ActiveRecord::Migration[5.1]
  def change
    add_index :saltedge_transactions, :saltedge_id, unique: true
  end
end
