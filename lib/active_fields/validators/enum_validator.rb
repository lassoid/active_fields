# frozen_string_literal: true

module ActiveFields
  module Validators
    class EnumValidator < BaseValidator
      private

      def perform_validation(value)
        if value.nil?
          errors << :required if options[:required]
        elsif options[:allowed_values].is_a?(Array)
          validate_value_allowed(value, allowed_values: options[:allowed_values])
        end
      end

      def validate_value_allowed(value, allowed_values:)
        return if allowed_values.include?(value)

        errors << :inclusion
      end
    end
  end
end
