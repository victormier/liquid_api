class LoadAllTransactionsWorker
  include Sidekiq::Worker

  def perform
    VirtualAccount.mirror.each do |virtual_account|
      LoadTransactionsWorker.perform_async(virtual_account.saltedge_account.id)
    end
  end
end
