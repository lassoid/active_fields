# frozen_string_literal: true

module ActiveFields
  module Casters
    class IntegerCaster < BaseCaster
      def serialize(value)
        cast(value)
      end

      def deserialize(value)
        cast(value)
      end

      private

      def cast(value)
        BigDecimal(value, 0, exception: false)&.to_i
      end
    end
  end
end
