class UpdateSaltedgeAccountWorker
  include Sidekiq::Worker

  def perform(saltedge_account_id)
    if saltedge_account = SaltedgeAccount.find(saltedge_account_id)
      Services::UpdateSaltedgeAccount.new(saltedge_account).call
    end
  end
end
