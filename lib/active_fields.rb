# frozen_string_literal: true

require_relative "active_fields/version"
Dir["#{__dir__}/active_fields/casters/**/*.rb"].each { |f| require_relative f }
Dir["#{__dir__}/active_fields/validators/**/*.rb"].each { |f| require_relative f }
Dir["#{__dir__}/active_fields/models/**/*.rb"].each { |f| require_relative f }

module ActiveFields
  class Error < StandardError; end
end
