# frozen_string_literal: true

module ActiveFields
  module Finders
    class DateArrayFinder < BaseFinder
      def search(operator:, value:)
        caster = Casters::DateCaster.new
        value = caster.serialize(caster.deserialize(value))

        case operator.to_s
        when "include"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.date() == $value.date())", { value: value }),
          )
        when "not_include"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.date() == $value.date())", { value: value }),
          )
        when "any_gt"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.date() > $value.date())", { value: value }),
          )
        when "any_gte"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.date() >= $value.date())", { value: value }),
          )
        when "any_lt"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.date() < $value.date())", { value: value }),
          )
        when "any_lte"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@.date() <= $value.date())", { value: value }),
          )
        when "all_gt"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.date() <= $value.date())", { value: value }),
          )
        when "all_gte"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.date() < $value.date())", { value: value }),
          )
        when "all_lt"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.date() >= $value.date())", { value: value }),
          )
        when "all_lte"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@.date() > $value.date())", { value: value }),
          )
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
