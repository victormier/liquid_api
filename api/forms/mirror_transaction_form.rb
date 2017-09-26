require 'api/forms/transaction_form'

class MirrorTransactionForm < TransactionForm
  property :saltedge_transaction

  validation do
    required(:saltedge_transaction).filled
  end

  def made_on=(made_on_date)
  end
end
