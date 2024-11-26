# frozen_string_literal: true

module ActiveFields
  module Finders
    class IntegerFinder < BaseFinder
      def search(operator:, value:)
        value = Casters::IntegerCaster.new.deserialize(value)

        case operator
        when "=", "eq"
          active_values_cte.where(casted_value_field("integer").eq(value))
        when "!=", "not_eq"
          active_values_cte.where(casted_value_field("integer").not_eq(value))
        when ">", "gt"
          active_values_cte.where(casted_value_field("integer").gt(value))
        when "=>", "gte"
          active_values_cte.where(casted_value_field("integer").gteq(value))
        when "<", "lt"
          active_values_cte.where(casted_value_field("integer").lt(value))
        when "<=", "lte"
          active_values_cte.where(casted_value_field("integer").lteq(value))
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
