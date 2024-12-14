# frozen_string_literal: true

module ActiveFields
  module Finders
    class DateTimeArrayFinder < ArrayFinder
      def search(operator:, value:)
        case operator.to_s
        when *OPS[:include]
          scope.where(value_match_any("==", cast(value)))
        when *OPS[:not_include]
          scope.where.not(value_match_any("==", cast(value)))
        when *OPS[:any_gt]
          scope.where(value_match_any(">", cast(value)))
        when *OPS[:any_gteq]
          scope.where(value_match_any(">=", cast(value)))
        when *OPS[:any_lt]
          scope.where(value_match_any("<", cast(value)))
        when *OPS[:any_lteq]
          scope.where(value_match_any("<=", cast(value)))
        when *OPS[:all_gt]
          scope.where(value_match_all(">", cast(value)))
        when *OPS[:all_gteq]
          scope.where(value_match_all(">=", cast(value)))
        when *OPS[:all_lt]
          scope.where(value_match_all("<", cast(value)))
        when *OPS[:all_lteq]
          scope.where(value_match_all("<=", cast(value)))
        when *OPS[:size_eq]
          scope.where(value_size_eq(cast_int(value)))
        when *OPS[:size_not_eq]
          scope.where(value_size_not_eq(cast_int(value)))
        when *OPS[:size_gt]
          scope.where(value_size_gt(cast_int(value)))
        when *OPS[:size_gteq]
          scope.where(value_size_gteq(cast_int(value)))
        when *OPS[:size_lt]
          scope.where(value_size_lt(cast_int(value)))
        when *OPS[:size_lteq]
          scope.where(value_size_lteq(cast_int(value)))
        else
          operator_not_found!(operator)
        end
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
