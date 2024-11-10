# frozen_string_literal: true

module ActiveFields
  module Finders
    class DateTimeArrayFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          caster = Casters::DateTimeCaster.new(precision: active_field.precision)
          value = caster.serialize(caster.deserialize(value))
          scope = active_values_cte(active_field)

          case operator
          when "include"
            scope.where(value_field_match("$[*] ? (@.timestamp() == #{value.to_json}.timestamp())"))
          when "not_include"
            scope.where.not(value_field_match("$[*] ? (@.timestamp() == #{value.to_json}.timestamp())"))
          when "any_gt"
            scope.where(value_field_match("$[*] ? (@.timestamp() > #{value.to_json}.timestamp())"))
          when "any_gte"
            scope.where(value_field_match("$[*] ? (@.timestamp() >= #{value.to_json}.timestamp())"))
          when "any_lt"
            scope.where(value_field_match("$[*] ? (@.timestamp() < #{value.to_json}.timestamp())"))
          when "any_lte"
            scope.where(value_field_match("$[*] ? (@.timestamp() <= #{value.to_json}.timestamp())"))
          when "all_gt"
            scope.where.not(value_field_match("$[*] ? (@.timestamp() <= #{value.to_json}.timestamp())"))
          when "all_gte"
            scope.where.not(value_field_match("$[*] ? (@.timestamp() < #{value.to_json}.timestamp())"))
          when "all_lt"
            scope.where.not(value_field_match("$[*] ? (@.timestamp() >= #{value.to_json}.timestamp())"))
          when "all_lte"
            scope.where.not(value_field_match("$[*] ? (@.timestamp() > #{value.to_json}.timestamp())"))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
