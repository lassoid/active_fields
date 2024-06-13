# frozen_string_literal: true

module ActiveFields
  module Validators
    class DateValidator < BaseValidator
      private

      def perform_validation(value)
        if value.nil?
          errors << :required if active_field.required?
        elsif value.is_a?(Date)
          validate_minmax(value, min: active_field.min, max: active_field.max)
        else
          errors << :invalid
        end
      end
    end
  end
end
