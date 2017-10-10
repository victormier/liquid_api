class AddRuleToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :rule_id, :integer
    add_index :transactions, :rule_id
  end
end
