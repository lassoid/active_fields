# frozen_string_literal: true

module ActiveFields
  module Finders
    class DecimalFinder < BaseFinder
      def search(operator:, value:)
        value = Casters::DecimalCaster.new.deserialize(value)

        case operator
        when "=", "eq"
          active_values_cte.where(casted_value_field("decimal").eq(value))
        when "!=", "not_eq"
          active_values_cte.where(casted_value_field("decimal").not_eq(value))
        when ">", "gt"
          active_values_cte.where(casted_value_field("decimal").gt(value))
        when "=>", "gte"
          active_values_cte.where(casted_value_field("decimal").gteq(value))
        when "<", "lt"
          active_values_cte.where(casted_value_field("decimal").lt(value))
        when "<=", "lte"
          active_values_cte.where(casted_value_field("decimal").lteq(value))
        else
          raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{self.class.name}`"
        end
      end
    end
  end
end
