# frozen_string_literal: true

module ActiveFields
  module Validators
    class DateValidator < BaseValidator
      private

      def perform_validation(value)
        if value.nil?
          errors << :required if options[:required]
        elsif value.acts_like?(:date)
          validate_minmax(value, min: options[:min], max: options[:max])
        else
          errors << :invalid
        end
      end
    end
  end
end
