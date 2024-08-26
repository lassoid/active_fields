# frozen_string_literal: true

module ActiveFields
  module Casters
    class DateTimeCaster < BaseCaster
      def serialize(value)
        cast(value)&.iso8601
      end

      def deserialize(value)
        cast(value)
      end

      private

      def cast(value)
        casted_value = ActiveModel::Type::DateTime.new.cast(value)

        casted_value if casted_value.acts_like?(:time)
      end
    end
  end
end
