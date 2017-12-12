class AddCustomCategoryToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :custom_category, :string
  end
end
