# frozen_string_literal: true

module ActiveFields
  module Finders
    class IntegerFinder < BaseFinder
      class << self
        def call(scope:, operator:, value:)
          raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
        end
      end
    end
  end
end
