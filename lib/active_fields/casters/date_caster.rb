# frozen_string_literal: true

require_relative "base_caster"

module ActiveFields
  module Casters
    class DateCaster < BaseCaster
      def serialize(value)
        cast(value)&.iso8601
      end

      def deserialize(value)
        cast(value)
      end

      private

      def cast(value)
        casted_value = ActiveModel::Type::Date.new.cast(value)

        casted_value if casted_value.acts_like?(:date)
      end
    end
  end
end
