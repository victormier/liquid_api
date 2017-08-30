class CreateSaltedgeLogins < ActiveRecord::Migration[5.1]
  def change
    create_table :saltedge_logins do |t|
      t.integer :user_id, null: false
      t.integer :saltedge_provider_id
      t.string :saltedge_id
      t.text :saltedge_data
    end

    add_index :saltedge_logins, :user_id
    add_index :saltedge_logins, :saltedge_provider_id
  end
end
