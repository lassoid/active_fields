# frozen_string_literal: true

module ActiveFields
  module Casters
    class DecimalCaster < BaseCaster
      def serialize(value)
        # Decimals should be saved as strings to avoid potential precision loss when stored in JSON
        cast(value)&.to_s
      end

      def deserialize(value)
        cast(value)
      end

      private

      def cast(value)
        casted = BigDecimal(value, 0, exception: false)
        casted = casted.truncate(precision) if casted && precision

        casted
      end

      def precision
        options[:precision]
      end
    end
  end
end
