# frozen_string_literal: true

module ActiveFields
  module Finders
    class DateTimeFinder < SingularFinder
      operation :eq, operator: OPS[:eq] do |value|
        scope.where(eq(casted_value_field("timestamp"), cast(value)))
      end
      operation :not_eq, operator: OPS[:not_eq] do |value|
        scope.where(not_eq(casted_value_field("timestamp"), cast(value)))
      end
      operation :gt, operator: OPS[:gt] do |value|
        scope.where(gt(casted_value_field("timestamp"), cast(value)))
      end
      operation :gteq, operator: OPS[:gteq] do |value|
        scope.where(gteq(casted_value_field("timestamp"), cast(value)))
      end
      operation :lt, operator: OPS[:lt] do |value|
        scope.where(lt(casted_value_field("timestamp"), cast(value)))
      end
      operation :lteq, operator: OPS[:lteq] do |value|
        scope.where(lteq(casted_value_field("timestamp"), cast(value)))
      end

      private

      def cast(value)
        Casters::DateTimeCaster.new(precision: active_field.precision).deserialize(value)
      end
    end
  end
end
