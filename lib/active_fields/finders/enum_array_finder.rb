# frozen_string_literal: true

module ActiveFields
  module Finders
    class EnumArrayFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
        end
      end
    end
  end
end
