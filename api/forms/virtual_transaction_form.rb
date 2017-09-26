class VirtualTransactionForm < TransactionForm
  property :related_virtual_account
  property :virtual_transaction

  validation do
    required(:related_virtual_account).filled
  end
end
