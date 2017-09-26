class AddForeignKeys < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :virtual_accounts, :saltedge_accounts, on_delete: :cascade
    add_foreign_key :virtual_accounts, :users, on_delete: :cascade

    add_foreign_key :transactions, :virtual_accounts, on_delete: :cascade
    add_foreign_key :transactions, :saltedge_transactions, on_delete: :cascade
    add_foreign_key :transactions, :virtual_accounts, column: :related_virtual_account_id
    ## add_foreign_key :transactions, :transactions

    add_foreign_key :saltedge_transactions, :saltedge_accounts, on_delete: :cascade

    add_foreign_key :saltedge_accounts, :saltedge_logins, on_delete: :cascade
    add_foreign_key :saltedge_accounts, :users, on_delete: :cascade

    add_foreign_key :saltedge_logins, :users, on_delete: :cascade
  end
end
