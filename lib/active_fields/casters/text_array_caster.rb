# frozen_string_literal: true

require_relative "text_caster"

module ActiveFields
  module Casters
    class TextArrayCaster < TextCaster
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
