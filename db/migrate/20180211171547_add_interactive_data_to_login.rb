class AddInteractiveDataToLogin < ActiveRecord::Migration[5.1]
  def change
    add_column :saltedge_logins, :interactive_data, :text
  end
end
