# frozen_string_literal: true

require_relative "base_validator"

module ActiveFields
  module Validators
    class EnumValidator < BaseValidator
      private

      def perform_validation(value)
        if value.nil?
          errors << :required if active_field.required?
        elsif active_field.allowed_values.is_a?(Array)
          validate_value_allowed(value, allowed_values: active_field.allowed_values)
        end
      end

      def validate_value_allowed(value, allowed_values:)
        return if allowed_values.include?(value)

        errors << :inclusion
      end
    end
  end
end
