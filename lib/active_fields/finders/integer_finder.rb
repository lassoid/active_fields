# frozen_string_literal: true

module ActiveFields
  module Finders
    class IntegerFinder < BaseFinder
      def search(operator:, value:)
        value = Casters::IntegerCaster.new.deserialize(value)

        case operator.to_s
        when "=", "eq"
          active_values_cte.where(eq(casted_value_field("bigint"), value))
        when "!=", "not_eq"
          active_values_cte.where(not_eq(casted_value_field("bigint"), value))
        when ">", "gt"
          active_values_cte.where(gt(casted_value_field("bigint"), value))
        when ">=", "gteq", "gte"
          active_values_cte.where(gteq(casted_value_field("bigint"), value))
        when "<", "lt"
          active_values_cte.where(lt(casted_value_field("bigint"), value))
        when "<=", "lteq", "lte"
          active_values_cte.where(lteq(casted_value_field("bigint"), value))
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
