class TransactionForm < BaseForm
  property :made_on
  property :amount
  property :virtual_account

  validation do
    required(:made_on).filled
    required(:amount).filled
    required(:virtual_account).filled
  end
end
