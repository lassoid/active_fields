# frozen_string_literal: true

module ActiveFields
  module Casters
    class DateCaster < BaseCaster
      def serialize(value)
        casted_value = caster.serialize(value)

        casted_value.iso8601 if casted_value.is_a?(Date)
      end

      def deserialize(value)
        casted_value = caster.deserialize(value)

        casted_value if casted_value.is_a?(Date)
      end

      private

      def caster
        ActiveRecord::Type::Date.new
      end
    end
  end
end
