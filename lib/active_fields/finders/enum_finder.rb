# frozen_string_literal: true

module ActiveFields
  module Finders
    class EnumFinder < BaseFinder
      def search(operator:, value:)
        value = Casters::EnumCaster.new.deserialize(value)

        case operator
        when "=", "eq"
          active_values_cte.where(casted_value_field("text").eq(value))
        when "!=", "not_eq"
          active_values_cte.where(casted_value_field("text").not_eq(value))
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
