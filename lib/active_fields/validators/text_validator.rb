# frozen_string_literal: true

module ActiveFields
  module Validators
    class TextValidator < BaseValidator
      private

      def perform_validation(value)
        if value.nil?
          errors << :required if options[:required]
        elsif value.is_a?(String)
          validate_length(value, min: options[:min_length], max: options[:max_length])
        else
          errors << :invalid
        end
      end
    end
  end
end
