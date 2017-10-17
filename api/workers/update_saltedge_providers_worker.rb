class UpdateSaltedgeProvidersWorker
  include Sidekiq::Worker

  def perform
    Services::UpdateSaltedgeProviders.new.call
  end
end
