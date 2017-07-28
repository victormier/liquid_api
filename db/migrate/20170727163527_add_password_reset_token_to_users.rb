class AddPasswordResetTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_token_generated_at, :datetime
  end
end
