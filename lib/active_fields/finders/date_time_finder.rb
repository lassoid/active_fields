# frozen_string_literal: true

module ActiveFields
  module Finders
    class DateTimeFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          value = Casters::DateTimeCaster.new.deserialize(value)
          scope = active_values_cte(active_field)

          case operator
          when "=", "eq"
            scope.where(casted_value_field("timestamp").eq(value))
          when "!=", "not_eq"
            scope.where(casted_value_field("timestamp").not_eq(value))
          when ">", "gt"
            scope.where(casted_value_field("timestamp").gt(value))
          when "=>", "gte"
            scope.where(casted_value_field("timestamp").gteq(value))
          when "<", "lt"
            scope.where(casted_value_field("timestamp").lt(value))
          when "<=", "lte"
            scope.where(casted_value_field("timestamp").lteq(value))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
