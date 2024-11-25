# frozen_string_literal: true

module ActiveFields
  module Finders
    class EnumArrayFinder < BaseFinder
      def search(operator:, value:)
        caster = Casters::EnumCaster.new
        value = caster.serialize(caster.deserialize(value))

        case operator
        when "include"
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@ == $value)", { value: value }),
          )
        when "not_include"
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@ == $value)", { value: value }),
          )
        else
          raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{self.class.name}`"
        end
      end
    end
  end
end
