# frozen_string_literal: true

module ActiveFields
  module Casters
    class EnumArrayCaster < EnumCaster
      def serialize(value)
        return unless value.is_a?(Array)

        value.map { super(_1) }
      end

      def deserialize(value)
        return unless value.is_a?(Array)

        value.map { super(_1) }
      end
    end
  end
end
