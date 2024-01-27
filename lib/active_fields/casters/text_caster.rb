# frozen_string_literal: true

module ActiveFields
  module Casters
    class TextCaster < BaseCaster
      def serialize(value)
        value&.to_s
      end
    end
  end
end
