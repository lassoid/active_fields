# frozen_string_literal: true

require_relative "base_caster"

module ActiveFields
  module Casters
    class IntegerCaster < DecimalCaster
      def serialize(value)
        cast(value)
      end

      def deserialize(value)
        cast(value)
      end

      private

      def cast(value)
        super&.to_i
      end
    end
  end
end
