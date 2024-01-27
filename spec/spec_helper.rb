# frozen_string_literal: true

require "pg"
require "active_record"
require "logger"
require "factory_bot"
require "database_cleaner/active_record"

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
  ActiveRecord::Migration.run(CreateAuthorsAndPosts, CreateActiveFieldsTables)
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include TestMethods

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

RSpec::Matchers.define_negated_matcher :not_change, :change
RSpec::Matchers.define_negated_matcher :exclude, :include

reinitialize_database

require_relative "dummy_app/app"
