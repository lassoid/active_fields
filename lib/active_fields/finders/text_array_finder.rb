# frozen_string_literal: true

module ActiveFields
  module Finders
    class TextArrayFinder < BaseFinder
      class << self
        def call(active_field:, operator:, value:)
          caster = Casters::TextCaster.new
          value = caster.serialize(caster.deserialize(value))
          scope = active_values_cte(active_field)

          case operator
          when "include"
            scope.where(value_field_match("$[*] ? (@ == #{value.to_json})"))
          when "not_include"
            scope.where.not(value_field_match("$[*] ? (@ == #{value.to_json})"))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
