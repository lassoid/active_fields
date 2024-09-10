# frozen_string_literal: true

p "Loaded ActiveFields::Validators::BooleanValidator"
module ActiveFields
  module Validators
    class BooleanValidator < BaseValidator
      private

      def perform_validation(value)
        if value.nil?
          errors << :exclusion unless options[:nullable]
        elsif value.is_a?(FalseClass)
          errors << :required if options[:required]
        elsif value.is_a?(TrueClass)
          nil
        else
          errors << :invalid
        end
      end
    end
  end
end
