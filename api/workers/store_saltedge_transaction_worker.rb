class StoreSaltedgeTransactionWorker
  include Sidekiq::Worker

  def perform(saltedge_account_id, transaction_data)
    Services::SaveSaltedgeTransaction.new(saltedge_account_id, transaction_data).call
  end
end
