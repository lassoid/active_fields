# frozen_string_literal: true

module ActiveFields
  module Finders
    class TextArrayFinder < ArrayFinder
      operation :include, operators: OPS[:include] do |value|
        scope.where(value_match_any("==", cast(value)))
      end
      operation :not_include, operators: OPS[:not_include] do |value|
        scope.where.not(value_match_any("==", cast(value)))
      end
      operation :any_start_with, operators: OPS[:any_start_with] do |value|
        scope.where(value_match_any("starts with", cast(value)))
      end
      operation :all_start_with, operators: OPS[:all_start_with] do |value|
        scope.where(value_match_all("starts with", cast(value)))
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
        caster = Casters::TextCaster.new
        caster.serialize(caster.deserialize(value))
      end

      def jsonpath(operator) = "$[*] ? (@ #{operator} $value)"
    end
  end
end
