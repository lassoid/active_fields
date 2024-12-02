# frozen_string_literal: true

module ActiveFields
  module Finders
    class DateTimeArrayFinder < BaseFinder
      def search(operator:, value:)
        caster = Casters::DateTimeCaster.new(precision: active_field.precision)
        value = caster.serialize(caster.deserialize(value))

        case operator.to_s
        when *OPS[:include]
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() == $value.timestamp_tz())", { value: value }),
          )
        when *OPS[:not_include]
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() == $value.timestamp_tz())", { value: value }),
          )
        when *OPS[:any_gt]
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() > $value.timestamp_tz())", { value: value }),
          )
        when *OPS[:any_gteq]
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() >= $value.timestamp_tz())", { value: value }),
          )
        when *OPS[:any_lt]
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() < $value.timestamp_tz())", { value: value }),
          )
        when *OPS[:any_lteq]
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() <= $value.timestamp_tz())", { value: value }),
          )
        when *OPS[:all_gt]
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() <= $value.timestamp_tz())", { value: value }),
          )
        when *OPS[:all_gteq]
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() < $value.timestamp_tz())", { value: value }),
          )
        when *OPS[:all_lt]
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() >= $value.timestamp_tz())", { value: value }),
          )
        when *OPS[:all_lteq]
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() > $value.timestamp_tz())", { value: value }),
          )
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
