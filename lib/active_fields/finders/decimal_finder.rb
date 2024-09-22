# frozen_string_literal: true

module ActiveFields
  module Finders
    class DecimalFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          value = Casters::DecimalCaster.new.deserialize(value)
          scope = active_values_cte(active_field)

          case operator
          when "="
            scope.where(casted_value_field("decimal").eq(value))
          when ">"
            scope.where(casted_value_field("decimal").gt(value))
          when "=>"
            scope.where(casted_value_field("decimal").gteq(value))
          when "<"
            scope.where(casted_value_field("decimal").lt(value))
          when "<="
            scope.where(casted_value_field("decimal").lteq(value))
          when "!="
            scope.where(casted_value_field("decimal").not_eq(value))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
