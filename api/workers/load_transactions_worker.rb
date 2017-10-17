class LoadTransactionsWorker
  include Sidekiq::Worker

  def perform(saltedge_account_id)
    @saltedge_account = SaltedgeAccount.find(saltedge_account_id)
    Services::LoadSaltedgeAccountTransactions.new(@saltedge_account).call
  end
end
