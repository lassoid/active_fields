# frozen_string_literal: true

module ActiveFields
  module Finders
    class DateTimeFinder < BaseFinder
      def search(operator:, value:)
        value = Casters::DateTimeCaster.new.deserialize(value)

        case operator
        when "=", "eq"
          active_values_cte.where(casted_value_field("timestamp").eq(value))
        when "!=", "not_eq"
          active_values_cte.where(casted_value_field("timestamp").not_eq(value))
        when ">", "gt"
          active_values_cte.where(casted_value_field("timestamp").gt(value))
        when "=>", "gte"
          active_values_cte.where(casted_value_field("timestamp").gteq(value))
        when "<", "lt"
          active_values_cte.where(casted_value_field("timestamp").lt(value))
        when "<=", "lte"
          active_values_cte.where(casted_value_field("timestamp").lteq(value))
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
