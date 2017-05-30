require 'sequel'

namespace :db do
  task :environment do
    puts 'task environment'
  end
  desc "Run all migrations in db/migrate"
  task :migrate => :connect do
    Sequel.extension(:migration)
    Sequel::Migrator.apply(DB, "db/migrate")
  end

  task :seed => :connect do
    Sequel.extension(:seed)
    Sequel::Seeder.apply(DB, "db/seeds")
  end

  task :connect => :environment do
    require "./config/initializers/database"
    # Dir.glob('./models.rb').each { |file| require file }
    Dir.glob("./api/models/*.rb").each { |file| require file }
  end
end
