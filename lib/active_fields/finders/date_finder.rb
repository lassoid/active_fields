# frozen_string_literal: true

module ActiveFields
  module Finders
    class DateFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          value = Casters::DateCaster.new.deserialize(value)
          scope = active_values_cte(active_field)

          case operator
          when "=", "eq"
            scope.where(casted_value_field("date").eq(value))
          when "!=", "not_eq"
            scope.where(casted_value_field("date").not_eq(value))
          when ">", "gt"
            scope.where(casted_value_field("date").gt(value))
          when "=>", "gte"
            scope.where(casted_value_field("date").gteq(value))
          when "<", "lt"
            scope.where(casted_value_field("date").lt(value))
          when "<=", "lte"
            scope.where(casted_value_field("date").lteq(value))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
