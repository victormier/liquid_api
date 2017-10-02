class TransactionForm < BaseForm
  property :made_on
  property :amount
  property :virtual_account_id

  validation do
    required(:made_on).filled
    required(:amount).filled(:decimal?)
    required(:virtual_account_id).filled
  end
end
