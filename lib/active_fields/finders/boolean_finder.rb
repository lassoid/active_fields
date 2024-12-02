# frozen_string_literal: true

module ActiveFields
  module Finders
    class BooleanFinder < BaseFinder
      def search(operator:, value:)
        value = Casters::BooleanCaster.new.deserialize(value)

        case operator.to_s
        when *OPS[:eq]
          active_values_cte.where(eq(casted_value_field("boolean"), value))
        when *OPS[:not_eq]
          active_values_cte.where(not_eq(casted_value_field("boolean"), value))
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
