class CreateSaltedgeProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :saltedge_providers do |t|
      t.integer :saltedge_id
      t.text    :saltedge_data
      t.string  :status
      t.string  :mode
      t.string  :name
      t.boolean :automatic_fetch
      t.string  :country_code
      t.timestamps
    end
  end
end
