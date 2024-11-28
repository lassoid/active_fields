# frozen_string_literal: true

module ActiveFields
  module Finders
    class DecimalFinder < BaseFinder
      def search(operator:, value:)
        value = Casters::DecimalCaster.new(precision: active_field.precision).deserialize(value)

        case operator.to_s
        when "=", "eq"
          active_values_cte.where(eq(casted_value_field("decimal"), value))
        when "!=", "not_eq"
          active_values_cte.where(not_eq(casted_value_field("decimal"), value))
        when ">", "gt"
          active_values_cte.where(gt(casted_value_field("decimal"), value))
        when ">=", "gteq", "gte"
          active_values_cte.where(gteq(casted_value_field("decimal"), value))
        when "<", "lt"
          active_values_cte.where(lt(casted_value_field("decimal"), value))
        when "<=", "lteq", "lte"
          active_values_cte.where(lteq(casted_value_field("decimal"), value))
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
