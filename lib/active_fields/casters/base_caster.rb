# frozen_string_literal: true

module ActiveFields
  module Casters
    # Typecasts the active_value value
    class BaseCaster
      # To raw DB value
      def serialize(value)
        raise NotImplementedError
      end

      # From raw DB value
      def deserialize(value)
        raise NotImplementedError
      end
    end
  end
end
