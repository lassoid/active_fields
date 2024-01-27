# frozen_string_literal: true

module ActiveFields
  module Casters
    class IntegerArrayCaster < IntegerCaster
      def serialize(value)
        return value unless value.is_a?(Array)

        value.map { cast(_1) }
      end
    end
  end
end
