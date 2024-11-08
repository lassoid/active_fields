# frozen_string_literal: true

module ActiveFields
  module Finders
    class DecimalFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          value = Casters::DecimalCaster.new.deserialize(value)
          scope = active_values_cte(active_field)

          case operator
          when "=", "eq"
            scope.where(casted_value_field("decimal").eq(value))
          when "!=", "not_eq"
            scope.where(casted_value_field("decimal").not_eq(value))
          when ">", "gt"
            scope.where(casted_value_field("decimal").gt(value))
          when "=>", "gte"
            scope.where(casted_value_field("decimal").gteq(value))
          when "<", "lt"
            scope.where(casted_value_field("decimal").lt(value))
          when "<=", "lte"
            scope.where(casted_value_field("decimal").lteq(value))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
