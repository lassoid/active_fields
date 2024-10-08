# frozen_string_literal: true

module ActiveFields
  module Finders
    class IntegerFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          value = Casters::IntegerCaster.new.deserialize(value)
          scope = active_values_cte(active_field)

          case operator
          when "="
            scope.where(casted_value_field("integer").eq(value))
          when ">"
            scope.where(casted_value_field("integer").gt(value))
          when "=>"
            scope.where(casted_value_field("integer").gteq(value))
          when "<"
            scope.where(casted_value_field("integer").lt(value))
          when "<="
            scope.where(casted_value_field("integer").lteq(value))
          when "!="
            scope.where(casted_value_field("integer").not_eq(value))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
