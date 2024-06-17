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
        casted = BigDecimal(value, 0, exception: false)
        casted = casted.truncate(active_field.precision) if casted && active_field&.precision

        casted
      end
    end
  end
end
