# frozen_string_literal: true

require_relative "base_caster"

module ActiveFields
  module Casters
    class IntegerCaster < BaseCaster
      def serialize(value)
        cast(value)
      end

      private

      def cast(value)
        Integer(value, exception: false)
      end
    end
  end
end
