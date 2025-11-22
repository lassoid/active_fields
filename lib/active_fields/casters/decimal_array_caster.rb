# frozen_string_literal: true

module ActiveFields
  module Casters
    class DecimalArrayCaster < DecimalCaster
      def serialize(value)
        return unless value.is_a?(Array)

        value.map { |element| super(element) }
      end

      def deserialize(value)
        return unless value.is_a?(Array)

        value.map { |element| super(element) }
      end
    end
  end
end
