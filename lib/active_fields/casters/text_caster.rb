# frozen_string_literal: true

require_relative "base_caster"

module ActiveFields
  module Casters
    class TextCaster < BaseCaster
      def serialize(value)
        cast(value)
      end

      def deserialize(value)
        cast(value)
      end

      private

      def cast(value)
        value&.to_s
      end
    end
  end
end
