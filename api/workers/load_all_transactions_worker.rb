class LoadAllTransactionsWorker
  include Sidekiq::Worker

  def perform
    SaltedgeAccount.all.each do |saltedge_account|
      LoadTransactionsWorker.perform_async(saltedge_account.id)
    end
  end
end
