class AddKilledToSaltedgeLogins < ActiveRecord::Migration[5.1]
  def change
    add_column :saltedge_logins, :killed, :boolean, default: false
  end
end
