class CreateRules < ActiveRecord::Migration[5.1]
  def change
    create_table :rules do |t|
      t.integer :user_id
      t.integer :virtual_account_id
      t.text :config
      t.string :type
      t.timestamps
    end

    add_index :rules, :user_id
    add_foreign_key :rules, :users, on_delete: :cascade
  end
end
