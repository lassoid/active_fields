# frozen_string_literal: true

module ActiveFields
  module Finders
    class TextArrayFinder < ArrayFinder
      operation :include, operator: OPS[:include] do |value|
        scope.where(value_match_any("==", cast(value)))
      end
      operation :not_include, operator: OPS[:not_include] do |value|
        scope.where.not(value_match_any("==", cast(value)))
      end
      operation :any_start_with, operator: OPS[:any_start_with] do |value|
        scope.where(value_match_any("starts with", cast(value)))
      end
      operation :all_start_with, operator: OPS[:all_start_with] do |value|
        scope.where(value_match_all("starts with", cast(value)))
      end
      operation :size_eq, operator: OPS[:size_eq] do |value|
        scope.where(value_size_eq(value))
      end
      operation :size_not_eq, operator: OPS[:size_not_eq] do |value|
        scope.where(value_size_not_eq(value))
      end
      operation :size_gt, operator: OPS[:size_gt] do |value|
        scope.where(value_size_gt(value))
      end
      operation :size_gteq, operator: OPS[:size_gteq] do |value|
        scope.where(value_size_gteq(value))
      end
      operation :size_lt, operator: OPS[:size_lt] do |value|
        scope.where(value_size_lt(value))
      end
      operation :size_lteq, operator: OPS[:size_lteq] do |value|
        scope.where(value_size_lteq(value))
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
