# frozen_string_literal: true

require_relative "base_caster"

module ActiveFields
  module Casters
    class DateCaster < BaseCaster
      def serialize(value)
        deserialize(value)&.iso8601
      end

      def deserialize(value)
        casted_value = ActiveModel::Type::Date.new.cast(value)

        casted_value if casted_value.acts_like?(:date)
      end
    end
  end
end
