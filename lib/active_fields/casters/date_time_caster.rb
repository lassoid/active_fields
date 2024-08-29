# frozen_string_literal: true

module ActiveFields
  module Casters
    class DateTimeCaster < BaseCaster
      def serialize(value)
        cast(value)&.iso8601(precision)
      end

      def deserialize(value)
        cast(value)
      end

      private

      def cast(value)
        value = value.beginning_of_day if value.acts_like?(:date)
        casted_value = ActiveModel::Type::DateTime.new(precision: precision).cast(value)

        casted_value if casted_value.acts_like?(:time)
      end

      def precision
        active_field&.precision || 6
      end
    end
  end
end
