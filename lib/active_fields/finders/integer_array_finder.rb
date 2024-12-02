# frozen_string_literal: true

module ActiveFields
  module Finders
    class IntegerArrayFinder < BaseFinder
      def search(operator:, value:)
        caster = Casters::IntegerCaster.new
        value = caster.serialize(caster.deserialize(value))

        case operator.to_s
        when *OPS[:include]
          active_values_cte.where(value_match_any("==", value))
        when *OPS[:not_include]
          active_values_cte.where.not(value_match_any("==", value))
        when *OPS[:any_gt]
          active_values_cte.where(value_match_any(">", value))
        when *OPS[:any_gteq]
          active_values_cte.where(value_match_any(">=", value))
        when *OPS[:any_lt]
          active_values_cte.where(value_match_any("<", value))
        when *OPS[:any_lteq]
          active_values_cte.where(value_match_any("<=", value))
        when *OPS[:all_gt]
          active_values_cte.where(value_match_all(">", value))
        when *OPS[:all_gteq]
          active_values_cte.where(value_match_all(">=", value))
        when *OPS[:all_lt]
          active_values_cte.where(value_match_all("<", value))
        when *OPS[:all_lteq]
          active_values_cte.where(value_match_all("<=", value))
        else
          operator_not_found!(operator)
        end
      end

      private

      def value_match_any(operator, value)
        jsonb_path_exists(
          value_field_jsonb,
          "$[*] ? (@ #{operator} $value)",
          { value: value },
        )
      end

      def value_match_all(operator, value)
        jsonb_array_length(value_field_jsonb).gt(0)
          .and(
            jsonb_array_length(value_field_jsonb).eq(
              jsonb_array_length(
                jsonb_path_query_array(
                  value_field_jsonb,
                  "$[*] ? (@ #{operator} $value)",
                  { value: value },
                ),
              ),
            ),
          )
      end
    end
  end
end
