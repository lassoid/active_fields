# frozen_string_literal: true

require_relative "base_caster"

module ActiveFields
  module Casters
    class DecimalCaster < BaseCaster
      def serialize(value)
        cast(value)
      end

      private

      def cast(value)
        Float(value, exception: false)
      end
    end
  end
end
