class UpdateSaltedgeTransactionCategoryWorker
  include Sidekiq::Worker

  def perform(saltedge_transaction_id, category_code)
    if saltedge_transaction = SaltedgeTransaction.find(saltedge_transaction_id)
      Services::UpdateSaltedgeTransactionCategory.new(saltedge_transaction, category_code).call
    end
  end
end
