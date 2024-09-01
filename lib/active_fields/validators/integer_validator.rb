# frozen_string_literal: true

module ActiveFields
  module Validators
    class IntegerValidator < BaseValidator
      private

      def perform_validation(value)
        if value.nil?
          errors << :required if options[:required]
        elsif value.is_a?(Numeric)
          validate_minmax(value, min: options[:min], max: options[:max])
        else
          errors << :invalid
        end
      end
    end
  end
end
