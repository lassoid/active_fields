# frozen_string_literal: true

module ActiveFields
  module Casters
    # Typecasts the active_value value
    class BaseCaster
      attr_reader :active_field

      def initialize(active_field)
        @active_field = active_field
      end

      def serialize(value)
        raise NotImplementedError
      end

      def deserialize(value)
        serialize(value)
      end
    end
  end
end
