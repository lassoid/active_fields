# frozen_string_literal: true

module ActiveFields
  module Casters
    class EnumArrayCaster < BaseCaster
      def serialize(value)
        return value unless value.is_a?(Array)

        value.map { _1&.to_s }
      end
    end
  end
end
