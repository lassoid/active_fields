# frozen_string_literal: true

module ActiveFields
  module Validators
    class EnumArrayValidator < BaseValidator
      private

      def perform_validation(value)
        unless value.is_a?(Array)
          errors << :invalid
          return
        end

        validate_size(value, min: options[:min_size], max: options[:max_size])

        if options[:allowed_values].is_a?(Array)
          value.each do |elem_value|
            validate_value_allowed(elem_value, allowed_values: options[:allowed_values])
          end
        end

        if value.size != value.uniq.size
          errors << :duplicate
        end
      end

      def validate_value_allowed(value, allowed_values:)
        return if allowed_values.include?(value)

        errors << :inclusion
      end
    end
  end
end
