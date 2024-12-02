# frozen_string_literal: true

module ActiveFields
  module Finders
    class DecimalFinder < BaseFinder
      def search(operator:, value:)
        value = Casters::DecimalCaster.new(precision: active_field.precision).deserialize(value)

        case operator.to_s
        when *OPS[:eq]
          active_values_cte.where(eq(casted_value_field("decimal"), value))
        when *OPS[:not_eq]
          active_values_cte.where(not_eq(casted_value_field("decimal"), value))
        when *OPS[:gt]
          active_values_cte.where(gt(casted_value_field("decimal"), value))
        when *OPS[:gteq]
          active_values_cte.where(gteq(casted_value_field("decimal"), value))
        when *OPS[:lt]
          active_values_cte.where(lt(casted_value_field("decimal"), value))
        when *OPS[:lteq]
          active_values_cte.where(lteq(casted_value_field("decimal"), value))
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
