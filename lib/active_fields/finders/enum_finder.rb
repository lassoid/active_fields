# frozen_string_literal: true

module ActiveFields
  module Finders
    class EnumFinder < SingularFinder
      def search(operator:, value:)
        case operator.to_s
        when *OPS[:eq]
          scope.where(eq(casted_value_field("text"), cast(value)))
        when *OPS[:not_eq]
          scope.where(not_eq(casted_value_field("text"), cast(value)))
        else
          operator_not_found!(operator)
        end
      end

      private

      def cast(value)
        Casters::EnumCaster.new.deserialize(value)
      end
    end
  end
end
