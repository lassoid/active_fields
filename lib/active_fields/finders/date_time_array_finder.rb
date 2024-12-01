# frozen_string_literal: true

module ActiveFields
  module Finders
    class DateTimeArrayFinder < BaseFinder
      def search(operator:, value:)
        caster = Casters::DateTimeCaster.new(precision: active_field.precision)
        value = caster.serialize(caster.deserialize(value))

        case operator.to_s
        when "|=", "include"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() == $value.timestamp_tz())", { value: value }),
          )
        when "!|=", "not_include"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() == $value.timestamp_tz())", { value: value }),
          )
        when "|>", "any_gt"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() > $value.timestamp_tz())", { value: value }),
          )
        when "|>=", "any_gteq", "any_gte"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() >= $value.timestamp_tz())", { value: value }),
          )
        when "|<", "any_lt"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() < $value.timestamp_tz())", { value: value }),
          )
        when "|<=", "any_lteq", "any_lte"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() <= $value.timestamp_tz())", { value: value }),
          )
        when "&>", "all_gt"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() <= $value.timestamp_tz())", { value: value }),
          )
        when "&>=", "all_gteq", "all_gte"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() < $value.timestamp_tz())", { value: value }),
          )
        when "&<", "all_lt"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.timestamp_tz() >= $value.timestamp_tz())", { value: value }),
          )
        when "&<=", "all_lteq", "all_lte"
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
