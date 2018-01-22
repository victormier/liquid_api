class AddHasInteractiveFieldsToSaltedgeProviders < ActiveRecord::Migration[5.1]
  def up
    add_column :saltedge_providers, :interactive, :boolean, default: false

    # IMP: Run rake scheduler:update_saltedge_providers after running the migration
  end

  def down
    remove_column :saltedge_providers, :interactive
  end
end
