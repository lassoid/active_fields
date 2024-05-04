# frozen_string_literal: true

require_relative "date_caster"

module ActiveFields
  module Casters
    class DateArrayCaster < DateCaster
      def serialize(value)
        return unless value.is_a?(Array)

        value.map { super(_1) }
      end

      def deserialize(value)
        return unless value.is_a?(Array)

        value.map { super(_1) }
      end
    end
  end
end
