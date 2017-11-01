class AddSaltedgeIdToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :saltedge_id, :string
    add_index  :transactions, [:made_on, :saltedge_id], order: { made_on: :desc, saltedge_id: :desc }
  end
end
