# frozen_string_literal: true

module ActiveFields
  module Finders
    class IntegerFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          value = Casters::IntegerCaster.new.deserialize(value)
          scope = active_values_cte(active_field)

          case operator
          when "=", "eq"
            scope.where(casted_value_field("integer").eq(value))
          when "!=", "not_eq"
            scope.where(casted_value_field("integer").not_eq(value))
          when ">", "gt"
            scope.where(casted_value_field("integer").gt(value))
          when "=>", "gte"
            scope.where(casted_value_field("integer").gteq(value))
          when "<", "lt"
            scope.where(casted_value_field("integer").lt(value))
          when "<=", "lte"
            scope.where(casted_value_field("integer").lteq(value))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
