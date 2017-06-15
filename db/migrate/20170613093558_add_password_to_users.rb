class AddPasswordToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_digest, :string, null: false
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
  end
end
