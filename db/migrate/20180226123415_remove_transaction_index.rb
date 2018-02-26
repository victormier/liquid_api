class RemoveTransactionIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :saltedge_transactions, :saltedge_id
  end
end
