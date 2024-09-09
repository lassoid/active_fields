# frozen_string_literal: true

module ActiveFields
  module Casters
    # Typecasts the active_value value
    class BaseCaster
      p "Loaded ActiveFields::Casters::BaseCaster"
      attr_reader :options

      def initialize(**options)
        @options = options
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
