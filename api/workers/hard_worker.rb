class HardWorker
  include Sidekiq::Worker
  def perform(name, count)
    p "#{name} IS WORKING HARD!!!!"
  end
end
