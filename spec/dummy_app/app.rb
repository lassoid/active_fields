# frozen_string_literal: true

require "active_fields"
require "active_record"
require "pg"
Dir["#{__dir__}/app/models/**/*.rb"].each { |f| require_relative f }
