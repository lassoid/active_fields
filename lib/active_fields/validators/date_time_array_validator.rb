# frozen_string_literal: true

module ActiveFields
  module Validators
    class DateTimeArrayValidator < BaseValidator
      private

      def perform_validation(value)
        unless value.is_a?(Array)
          errors << :invalid
          return
        end

        validate_size(value, min: options[:min_size], max: options[:max_size])

        value.each do |elem_value|
          if elem_value.acts_like?(:time)
            validate_minmax(elem_value, min: options[:min], max: options[:max])
          else
            errors << :invalid
          end
        end
      end
    end
  end
end
