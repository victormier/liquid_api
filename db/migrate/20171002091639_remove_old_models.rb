class RemoveOldModels < ActiveRecord::Migration[5.1]
  def change
    drop_table :posts
    drop_table :comments
    drop_table :categories
  end
end
