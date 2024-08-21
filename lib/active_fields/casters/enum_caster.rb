# frozen_string_literal: true

module ActiveFields
  module Casters
    class EnumCaster < BaseCaster
      def serialize(value)
        cast(value)
      end

      def deserialize(value)
        cast(value)
      end

      private

      def cast(value)
        value&.to_s.presence
      end
    end
  end
end
