# frozen_string_literal: true

module ActiveFields
  module Finders
    class BooleanFinder < BaseFinder
      class << self
        def call(scope:, operator:, value:)
          value = Casters::BooleanCaster.new.deserialize(value)
          case operator
          when "=", "is"
            scope.where(is_operation(casted_value_field("boolean"), value))
          when "!=", "is_not"
            scope.where(is_not_operation(casted_value_field("boolean"), value))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end