# frozen_string_literal: true

module ActiveFields
  module Finders
    class BooleanFinder < SingularFinder
      operation :eq, operator: OPS[:eq] do |value|
        scope.where(eq(casted_value_field("boolean"), cast(value)))
      end
      operation :not_eq, operator: OPS[:not_eq] do |value|
        scope.where(not_eq(casted_value_field("boolean"), cast(value)))
      end

      private

      def cast(value)
        Casters::BooleanCaster.new.deserialize(value)
      end
    end
  end
end
