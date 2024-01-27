# frozen_string_literal: true

module ActiveFields
  module Validators
    class IntegerArrayValidator < BaseValidator
      private

      def perform_validation(value)
        if value.is_a?(Array)
          validate_size(value, min: active_field.min_size, max: active_field.max_size)

          value.each do |elem_value|
            if elem_value.is_a?(Numeric)
              validate_minmax(elem_value, min: active_field.min, max: active_field.max)
            else
              errors << :invalid
            end
          end
        else
          errors << :invalid
        end
      end
    end
  end
end
