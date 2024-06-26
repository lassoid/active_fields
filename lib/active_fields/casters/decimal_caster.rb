# frozen_string_literal: true

module ActiveFields
  module Casters
    class DecimalCaster < BaseCaster
      def serialize(value)
        cast(value)
      end

      def deserialize(value)
        cast(value)
      end

      private

      def cast(value)
        BigDecimal(value, 0, exception: false)
      end
    end
  end
end
