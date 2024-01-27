# frozen_string_literal: true

module ActiveFields
  module Validators
    class TextValidator < BaseValidator
      private

      def perform_validation(value)
        if value.nil?
          errors << :required if active_field.min_length&.positive?
        elsif value.is_a?(String)
          validate_length(value, min: active_field.min_length, max: active_field.max_length)
        else
          errors << :invalid
        end
      end
    end
  end
end
