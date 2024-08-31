# frozen_string_literal: true

module ActiveFields
  module Casters
    class DateTimeCaster < BaseCaster
      def serialize(value)
        value = value.iso8601 if value.is_a?(Date)
        casted_value = caster.serialize(value)

        casted_value.iso8601(precision) if casted_value.acts_like?(:time)
      end

      def deserialize(value)
        value = value.iso8601 if value.is_a?(Date)
        casted_value = caster.deserialize(value)

        casted_value.in_time_zone if casted_value.acts_like?(:time)
      end

      private

      def caster
        ActiveRecord::Type::DateTime.new(precision: precision)
      end

      def precision
        active_field&.precision || 6
      end
    end
  end
end
