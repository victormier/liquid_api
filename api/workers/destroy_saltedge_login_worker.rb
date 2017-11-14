class DestroySaltedgeLoginWorker
  include Sidekiq::Worker

  def perform(saltedge_login_id)
    @saltedge_login = SaltedgeLogin.find(saltedge_login_id)
    @saltedge_login.destroy
  end
end
