class RemoveUserWorker
  include Sidekiq::Worker

  def perform(user_id)
    if user = User.find(user_id)
      Services::RemoveUser.new(user).call
    end
  end
end
