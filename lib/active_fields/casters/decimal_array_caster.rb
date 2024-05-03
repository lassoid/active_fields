# frozen_string_literal: true

require_relative "decimal_caster"

module ActiveFields
  module Casters
    class DecimalArrayCaster < DecimalCaster
      def serialize(value)
        return value unless value.is_a?(Array)

        value.map { super(_1) }
      end

      def deserialize(value)
        return value unless value.is_a?(Array)

        value.map { super(_1) }
      end
    end
  end
end
