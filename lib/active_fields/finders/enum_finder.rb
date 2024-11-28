# frozen_string_literal: true

module ActiveFields
  module Finders
    class EnumFinder < BaseFinder
      def search(operator:, value:)
        value = Casters::EnumCaster.new.deserialize(value)

        case operator.to_s
        when "=", "eq"
          active_values_cte.where(eq(casted_value_field("text"), value))
        when "!=", "not_eq"
          active_values_cte.where(not_eq(casted_value_field("text"), value))
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
