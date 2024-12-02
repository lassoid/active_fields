# frozen_string_literal: true

module ActiveFields
  module Finders
    class EnumArrayFinder < BaseFinder
      def search(operator:, value:)
        caster = Casters::EnumCaster.new
        value = caster.serialize(caster.deserialize(value))

        case operator.to_s
        when *OPS[:include]
          active_values_cte.where(value_match_any("==", value))
        when *OPS[:not_include]
          active_values_cte.where.not(value_match_any("==", value))
        else
          operator_not_found!(operator)
        end
      end

      private

      def value_match_any(operator, value)
        jsonb_path_exists(
          value_field_jsonb,
          "$[*] ? (@ #{operator} $value)",
          { value: value },
        )
      end
    end
  end
end
