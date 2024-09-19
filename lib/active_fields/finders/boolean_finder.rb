# frozen_string_literal: true

module ActiveFields
  module Finders
    class BooleanFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          value = Casters::BooleanCaster.new.deserialize(value)
          scope = active_values_cte(active_field)

          case operator
          when "=", "is"
            scope.where(is(casted_value_field("boolean"), value))
          when "!=", "is_not"
            scope.where(is_not(casted_value_field("boolean"), value))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
