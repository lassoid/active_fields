# frozen_string_literal: true

module ActiveFields
  module Finders
    class TextFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          value = Casters::TextCaster.new.deserialize(value)
          scope = active_values_cte(active_field)

          case operator
          when "="
            scope.where(casted_value_field("text").eq(value))
          when "!="
            scope.where(casted_value_field("text").not_eq(value))
          when "like"
            scope.where(casted_value_field("text").matches(value, nil, true))
          when "ilike"
            scope.where(casted_value_field("text").matches(value, nil, false))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
