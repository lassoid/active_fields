# frozen_string_literal: true

module ActiveFields
  module Finders
    class DateFinder < BaseFinder
      def search(operator:, value:)
        value = Casters::DateCaster.new.deserialize(value)

        case operator
        when "=", "eq"
          active_values_cte.where(casted_value_field("date").eq(value))
        when "!=", "not_eq"
          active_values_cte.where(casted_value_field("date").not_eq(value))
        when ">", "gt"
          active_values_cte.where(casted_value_field("date").gt(value))
        when "=>", "gte"
          active_values_cte.where(casted_value_field("date").gteq(value))
        when "<", "lt"
          active_values_cte.where(casted_value_field("date").lt(value))
        when "<=", "lte"
          active_values_cte.where(casted_value_field("date").lteq(value))
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
