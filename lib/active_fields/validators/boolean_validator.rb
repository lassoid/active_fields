# frozen_string_literal: true

require_relative "base_validator"

module ActiveFields
  module Validators
    class BooleanValidator < BaseValidator
      private

      def perform_validation(value)
        if value.nil?
          errors << :exclusion unless active_field.nullable?
        elsif value.is_a?(FalseClass)
          errors << :required if active_field.required?
        elsif value.is_a?(TrueClass)
          nil
        else
          errors << :invalid
        end
      end
    end
  end
end
