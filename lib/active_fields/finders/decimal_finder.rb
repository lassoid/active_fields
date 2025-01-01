# frozen_string_literal: true

module ActiveFields
  module Finders
    class DecimalFinder < SingularFinder
      operation :eq, operators: OPS[:eq] do |value|
        scope.where(eq(casted_value_field("decimal"), cast(value)))
      end
      operation :not_eq, operators: OPS[:not_eq] do |value|
        scope.where(not_eq(casted_value_field("decimal"), cast(value)))
      end
      operation :gt, operators: OPS[:gt] do |value|
        scope.where(gt(casted_value_field("decimal"), cast(value)))
      end
      operation :gteq, operators: OPS[:gteq] do |value|
        scope.where(gteq(casted_value_field("decimal"), cast(value)))
      end
      operation :lt, operators: OPS[:lt] do |value|
        scope.where(lt(casted_value_field("decimal"), cast(value)))
      end
      operation :lteq, operators: OPS[:lteq] do |value|
        scope.where(lteq(casted_value_field("decimal"), cast(value)))
      end

      private

      def cast(value)
        Casters::DecimalCaster.new(precision: active_field.precision).deserialize(value)
      end
    end
  end
end
