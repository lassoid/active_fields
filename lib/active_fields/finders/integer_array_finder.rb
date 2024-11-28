# frozen_string_literal: true

module ActiveFields
  module Finders
    class IntegerArrayFinder < BaseFinder
      def search(operator:, value:)
        caster = Casters::IntegerCaster.new
        value = caster.serialize(caster.deserialize(value))

        case operator.to_s
        when "include"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@ == $value)", { value: value }),
          )
        when "not_include"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@ == $value)", { value: value }),
          )
        when "any_gt"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@ > $value)", { value: value }),
          )
        when "any_gte"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@ >= $value)", { value: value }),
          )
        when "any_lt"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@ < $value)", { value: value }),
          )
        when "any_lte"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@ <= $value)", { value: value }),
          )
        when "all_gt"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@ <= $value)", { value: value }),
          )
        when "all_gte"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@ < $value)", { value: value }),
          )
        when "all_lt"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@ >= $value)", { value: value }),
          )
        when "all_lte"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@ > $value)", { value: value }),
          )
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
