# frozen_string_literal: true

module ActiveFields
  module Validators
    class EnumArrayValidator < BaseValidator
      private

      def perform_validation(value)
        if value.is_a?(Array)
          validate_size(value, min: active_field.min_size, max: active_field.max_size)

          value.each do |elem_value|
            validate_allowed_values(elem_value)
          end
        else
          errors << :invalid
        end
      end

      def validate_allowed_values(value)
        return if active_field.allowed_values.include?(value)

        errors << :inclusion
      end
    end
  end
end
