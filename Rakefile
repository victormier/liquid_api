require 'active_record_migrations'
require 'find'
require 'sidekiq'

require './config/initializers/sidekiq'

Find.find("./api/workers") { |f|
  require f unless f.match(/\/\..+$/) || File.directory?(f)
}

ActiveRecordMigrations.load_tasks

namespace :scheduler do
  task :test do
    p "Hello I'm a Rake Task!"
    HardWorker.perform_async("victor", 1)
  end

  task :load_all_transactions do
    p "Loading transactions task..."
    LoadAllTransactionsWorker.perform_async
  end

  task :update_saltedge_providers do
    p "Updating saltedge providers task..."
    UpdateSaltedgeProvidersWorker.perform_async
  end
end
