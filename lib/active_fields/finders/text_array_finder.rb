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
            scope.where(value_jsonb_path_exists("$[*] ? (@ == $value)", { value: value }))
          when "not_include"
            scope.where.not(value_jsonb_path_exists("$[*] ? (@ == $value)", { value: value }))
          else
            raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{name}`"
          end
        end
      end
    end
  end
end
