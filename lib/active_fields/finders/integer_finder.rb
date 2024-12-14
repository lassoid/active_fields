# frozen_string_literal: true

module ActiveFields
  module Finders
    class IntegerFinder < SingularFinder
      def search(operator:, value:)
        case operator.to_s
        when *OPS[:eq]
          scope.where(eq(casted_value_field("bigint"), cast(value)))
        when *OPS[:not_eq]
          scope.where(not_eq(casted_value_field("bigint"), cast(value)))
        when *OPS[:gt]
          scope.where(gt(casted_value_field("bigint"), cast(value)))
        when *OPS[:gteq]
          scope.where(gteq(casted_value_field("bigint"), cast(value)))
        when *OPS[:lt]
          scope.where(lt(casted_value_field("bigint"), cast(value)))
        when *OPS[:lteq]
          scope.where(lteq(casted_value_field("bigint"), cast(value)))
        else
          operator_not_found!(operator)
        end
      end

      private

      def cast(value)
        Casters::IntegerCaster.new.deserialize(value)
      end
    end
  end
end
