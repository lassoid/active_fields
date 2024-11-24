# frozen_string_literal: true

module ActiveFields
  module Finders
    class DateArrayFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          caster = Casters::DateCaster.new
          value = caster.serialize(caster.deserialize(value))
          scope = active_values_cte(active_field)

          case operator
          when "include"
            scope.where(value_jsonb_path_exists("$[*] ? (@.date() == $value.date())", { value: value }))
          when "not_include"
            scope.where.not(value_jsonb_path_exists("$[*] ? (@.date() == $value.date())", { value: value }))
          when "any_gt"
            scope.where(value_jsonb_path_exists("$[*] ? (@.date() > $value.date())", { value: value }))
          when "any_gte"
            scope.where(value_jsonb_path_exists("$[*] ? (@.date() >= $value.date())", { value: value }))
          when "any_lt"
            scope.where(value_jsonb_path_exists("$[*] ? (@.date() < $value.date())", { value: value }))
          when "any_lte"
            scope.where(value_jsonb_path_exists("$[*] ? (@.date() <= $value.date())", { value: value }))
          when "all_gt"
            scope.where.not(value_jsonb_path_exists("$[*] ? (@.date() <= $value.date())", { value: value }))
          when "all_gte"
            scope.where.not(value_jsonb_path_exists("$[*] ? (@.date() < $value.date())", { value: value }))
          when "all_lt"
            scope.where.not(value_jsonb_path_exists("$[*] ? (@.date() >= $value.date())", { value: value }))
          when "all_lte"
            scope.where.not(value_jsonb_path_exists("$[*] ? (@.date() > $value.date())", { value: value }))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
