# frozen_string_literal: true

module ActiveFields
  module Finders
    class BooleanFinder < SingularFinder
      operation :eq, operators: OPS[:eq] do |value|
        scope.where(eq(casted_value_field("boolean"), cast(value)))
      end
      operation :not_eq, operators: OPS[:not_eq] do |value|
        scope.where(not_eq(casted_value_field("boolean"), cast(value)))
      end

      private

      def cast(value)
        Casters::BooleanCaster.new.deserialize(value)
      end
    end
  end
end
