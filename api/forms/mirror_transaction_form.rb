require_relative 'transaction_form'

class MirrorTransactionForm < TransactionForm
  property :saltedge_transaction
  property :custom_category

  validation do
    required(:saltedge_transaction).filled
  end

  def made_on=(made_on_date)
  end
end
