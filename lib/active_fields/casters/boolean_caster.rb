# frozen_string_literal: true

module ActiveFields
  module Casters
    class BooleanCaster < BaseCaster
      def serialize(value)
        ActiveModel::Type::Boolean.new.cast(value)
      end
    end
  end
end
