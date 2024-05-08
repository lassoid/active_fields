# frozen_string_literal: true

require_relative "base_validator"

module ActiveFields
  module Validators
    class EnumArrayValidator < BaseValidator
      private

      def perform_validation(value)
        unless value.is_a?(Array)
          errors << :invalid
          return
        end

        validate_size(value, min: active_field.min_size, max: active_field.max_size)

        if active_field.allowed_values.is_a?(Array)
          value.each do |elem_value|
            validate_value_allowed(elem_value, allowed_values: active_field.allowed_values)
          end
        end

        if value.size != value.uniq.size
          errors << :taken
        end
      end

      def validate_value_allowed(value, allowed_values:)
        return if allowed_values.include?(value)

        errors << :inclusion
      end
    end
  end
end
