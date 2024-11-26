# frozen_string_literal: true

module ActiveFields
  module Finders
    class BooleanFinder < BaseFinder
      def search(operator:, value:)
        value = Casters::BooleanCaster.new.deserialize(value)

        case operator
        when "=", "eq"
          active_values_cte.where(is(casted_value_field("boolean"), value))
        when "!=", "not_eq"
          active_values_cte.where(is_not(casted_value_field("boolean"), value))
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
