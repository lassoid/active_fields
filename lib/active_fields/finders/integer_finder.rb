# frozen_string_literal: true

module ActiveFields
  module Finders
    class IntegerFinder < BaseFinder
      def search(operator:, value:)
        value = Casters::IntegerCaster.new.deserialize(value)

        case operator.to_s
        when *OPS[:eq]
          active_values_cte.where(eq(casted_value_field("bigint"), value))
        when *OPS[:not_eq]
          active_values_cte.where(not_eq(casted_value_field("bigint"), value))
        when *OPS[:gt]
          active_values_cte.where(gt(casted_value_field("bigint"), value))
        when *OPS[:gteq]
          active_values_cte.where(gteq(casted_value_field("bigint"), value))
        when *OPS[:lt]
          active_values_cte.where(lt(casted_value_field("bigint"), value))
        when *OPS[:lteq]
          active_values_cte.where(lteq(casted_value_field("bigint"), value))
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
