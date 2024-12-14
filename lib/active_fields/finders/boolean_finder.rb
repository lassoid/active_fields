# frozen_string_literal: true

module ActiveFields
  module Finders
    class BooleanFinder < SingularFinder
      def search(operator:, value:)
        case operator.to_s
        when *OPS[:eq]
          scope.where(eq(casted_value_field("boolean"), cast(value)))
        when *OPS[:not_eq]
          scope.where(not_eq(casted_value_field("boolean"), cast(value)))
        else
          operator_not_found!(operator)
        end
      end

      private

      def cast(value)
        Casters::BooleanCaster.new.deserialize(value)
      end
    end
  end
end
