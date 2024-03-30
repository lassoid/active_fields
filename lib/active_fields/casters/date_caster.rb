# frozen_string_literal: true

require_relative "base_caster"

module ActiveFields
  module Casters
    class DateCaster < BaseCaster
      def serialize(value)
        cast(value)
      end

      private

      def cast(value)
        if value.is_a?(String)
          Date.iso8601(value)
        elsif value.respond_to?(:to_date)
          value.to_date
        end
      rescue Date::Error
        nil
      end
    end
  end
end
