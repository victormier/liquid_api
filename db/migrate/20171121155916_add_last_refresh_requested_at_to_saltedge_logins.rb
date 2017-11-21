class AddLastRefreshRequestedAtToSaltedgeLogins < ActiveRecord::Migration[5.1]
  def change
    add_column :saltedge_logins, :last_refresh_requested_at, :datetime
  end
end
