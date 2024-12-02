# frozen_string_literal: true

module ActiveFields
  module Finders
    class TextArrayFinder < BaseFinder
      def search(operator:, value:)
        caster = Casters::TextCaster.new
        value = caster.serialize(caster.deserialize(value))

        case operator.to_s
        when *OPS[:include]
          active_values_cte.where(
            value_jsonb_path_exists("$[*] ? (@ == $value)", { value: value }),
          )
        when *OPS[:not_include]
          active_values_cte.where.not(
            value_jsonb_path_exists("$[*] ? (@ == $value)", { value: value }),
          )
        else
          operator_not_found!(operator)
        end
      end
    end
  end
end
