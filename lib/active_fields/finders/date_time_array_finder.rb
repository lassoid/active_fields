# frozen_string_literal: true

module ActiveFields
  module Finders
    class DateTimeArrayFinder < ArrayFinder
      operation :include, operators: OPS[:include] do |value|
        scope.where(value_match_any("==", cast(value)))
      end
      operation :not_include, operators: OPS[:not_include] do |value|
        scope.where.not(value_match_any("==", cast(value)))
      end
      operation :any_gt, operators: OPS[:any_gt] do |value|
        scope.where(value_match_any(">", cast(value)))
      end
      operation :any_gteq, operators: OPS[:any_gteq] do |value|
        scope.where(value_match_any(">=", cast(value)))
      end
      operation :any_lt, operators: OPS[:any_lt] do |value|
        scope.where(value_match_any("<", cast(value)))
      end
      operation :any_lteq, operators: OPS[:any_lteq] do |value|
        scope.where(value_match_any("<=", cast(value)))
      end
      operation :all_gt, operators: OPS[:all_gt] do |value|
        scope.where(value_match_all(">", cast(value)))
      end
      operation :all_gteq, operators: OPS[:all_gteq] do |value|
        scope.where(value_match_all(">=", cast(value)))
      end
      operation :all_lt, operators: OPS[:all_lt] do |value|
        scope.where(value_match_all("<", cast(value)))
      end
      operation :all_lteq, operators: OPS[:all_lteq] do |value|
        scope.where(value_match_all("<=", cast(value)))
      end
      operation :size_eq, operators: OPS[:size_eq] do |value|
        scope.where(value_size_eq(cast_int(value)))
      end
      operation :size_not_eq, operators: OPS[:size_not_eq] do |value|
        scope.where(value_size_not_eq(cast_int(value)))
      end
      operation :size_gt, operators: OPS[:size_gt] do |value|
        scope.where(value_size_gt(cast_int(value)))
      end
      operation :size_gteq, operators: OPS[:size_gteq] do |value|
        scope.where(value_size_gteq(cast_int(value)))
      end
      operation :size_lt, operators: OPS[:size_lt] do |value|
        scope.where(value_size_lt(cast_int(value)))
      end
      operation :size_lteq, operators: OPS[:size_lteq] do |value|
        scope.where(value_size_lteq(cast_int(value)))
      end

      private

      def cast(value)
        caster = Casters::DateTimeCaster.new(precision: active_field.precision)
        caster.serialize(caster.deserialize(value))
      end

      def jsonpath(operator) = "$[*] ? (@.timestamp_tz() #{operator} $value.timestamp_tz())"
    end
  end
end
