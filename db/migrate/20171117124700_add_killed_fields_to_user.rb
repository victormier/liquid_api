class AddKilledFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :will_be_removed_at, :datetime, default: nil
  end
end
