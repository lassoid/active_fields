# frozen_string_literal: true

require_relative "base_validator"

module ActiveFields
  module Validators
    class TextArrayValidator < BaseValidator
      private

      def perform_validation(value)
        unless value.is_a?(Array)
          errors << :invalid
          return
        end

        validate_size(value, min: active_field.min_size, max: active_field.max_size)

        value.each do |elem_value|
          if elem_value.is_a?(String)
            validate_length(elem_value, min: active_field.min_length, max: active_field.max_length)
          else
            errors << :invalid
          end
        end
      end
    end
  end
end
