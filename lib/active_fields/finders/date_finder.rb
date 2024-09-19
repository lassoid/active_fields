# frozen_string_literal: true

module ActiveFields
  module Finders
    class DateFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          value = Casters::DateCaster.new.deserialize(value)
          scope = active_values_cte(active_field)

          case operator
          when "="
            scope.where(casted_value_field("date").eq(value))
          when ">"
            scope.where(casted_value_field("date").gt(value))
          when "=>"
            scope.where(casted_value_field("date").gteq(value))
          when "<"
            scope.where(casted_value_field("date").lt(value))
          when "<="
            scope.where(casted_value_field("date").lteq(value))
          when "!="
            scope.where(casted_value_field("date").not_eq(value))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
