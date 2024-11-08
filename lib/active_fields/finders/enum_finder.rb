# frozen_string_literal: true

module ActiveFields
  module Finders
    class EnumFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          value = Casters::EnumCaster.new.deserialize(value)
          scope = active_values_cte(active_field)

          case operator
          when "=", "eq"
            scope.where(casted_value_field("text").eq(value))
          when "!=", "not_eq"
            scope.where(casted_value_field("text").not_eq(value))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
