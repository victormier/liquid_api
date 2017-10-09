class AddActiveToRules < ActiveRecord::Migration[5.1]
  def change
    add_column :rules, :active, :boolean, default: false
  end
end
