# frozen_string_literal: true

require_relative "base_validator"

module ActiveFields
  module Validators
    class EnumValidator < BaseValidator
      private

      def perform_validation(value)
        if value.nil?
          errors << :required if active_field.required?
        else
          validate_allowed_values(value)
        end
      end

      def validate_allowed_values(value)
        return if active_field.allowed_values.include?(value)

        errors << :inclusion
      end
    end
  end
end
