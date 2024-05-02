# frozen_string_literal: true

require_relative "base_caster"

module ActiveFields
  module Casters
    class BooleanCaster < BaseCaster
      def serialize(value)
        cast(value)
      end

      def deserialize(value)
        cast(value)
      end

      private

      def cast(value)
        ActiveModel::Type::Boolean.new.cast(value)
      end
    end
  end
end
