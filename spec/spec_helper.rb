# frozen_string_literal: true

require "pg"
require "active_record"
require "logger"
require "factory_bot"

Dir["#{__dir__}/support/**/*.rb"].each { |f| require f }

ActiveRecord::Base.logger = Logger.new("spec/log/log.txt")

FactoryBot.find_definitions

def reinitialize_database
  connection_options = {
    adapter: "postgresql",
    host: "localhost",
    port: 5432,
    encoding: "unicode",
    username: "postgres",
    password: "postgres",
  }
  database = "active_fields_test"

  db_connect(connection_options)
  db_drop(database) if db_exists?(database)
  db_create(database)

  db_connect(connection_options.merge(database: database))
  db_migrate
end

def db_exists?(database)
  ActiveRecord::Base.connection.select_value(
    "SELECT 1 FROM pg_catalog.pg_database WHERE datname = '#{database}'",
  ) == 1
end

def db_drop(database)
  ActiveRecord::Base.connection.drop_database(database)
end

def db_create(database)
  ActiveRecord::Base.connection.create_database(database)
end

def db_connect(options)
  ActiveRecord::Base.establish_connection(options)
end

def db_migrate
  Dir["#{__dir__}/dummy_app/db/migrate/*.rb"].each { |f| require_relative f }
  ActiveRecord::Migration.run(CreatePosts, CreateComments, CreateActiveFieldsTables)
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec::Matchers.define_negated_matcher :exclude, :include

reinitialize_database

require_relative "dummy_app/app"
