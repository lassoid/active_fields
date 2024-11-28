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
        BigDecimal(value, 0, exception: false)&.truncate(precision)
      end

      def precision
        [options[:precision], ActiveFields::MAX_DECIMAL_PRECISION].compact.min
      end
    end
  end
end
