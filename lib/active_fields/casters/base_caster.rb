# frozen_string_literal: true

module ActiveFields
  module Casters
    # Typecasts the active_value value
    class BaseCaster
      attr_reader :active_field

      def initialize(active_field)
        @active_field = active_field
      end

      # To raw AR attribute value
      def serialize(value)
        raise NotImplementedError
      end

      # From raw AR attribute value
      def deserialize(value)
        raise NotImplementedError
      end
    end
  end
end
