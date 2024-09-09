# frozen_string_literal: true

module ActiveFields
  module Validators
    # Validates the active_value value
    class BaseValidator
      p "Loaded ActiveFields::Validators::BaseValidator"
      attr_reader :options, :errors

      def initialize(**options)
        @options = options
        @errors = Set.new
      end

      # Performs the validation and adds errors to the `errors` list.
      # Returns `true` if no errors are found, `false` otherwise.
      def validate(value)
        perform_validation(value)
        valid?
      end

      # Returns `true` if no errors are found, `false` otherwise.
      def valid?
        errors.empty?
      end

      private

      # Performs the validation. If there are any errors, it should save them in `errors`.
      def perform_validation(value)
        raise NotImplementedError
      end

      def validate_size(value, min:, max:)
        if min && value.size < min
          errors << [:size_too_short, count: min]
        end

        if max && value.size > max
          errors << [:size_too_long, count: max]
        end
      end

      def validate_length(value, min:, max:)
        if min && value.length < min
          errors << [:too_short, count: min]
        end

        if max && value.length > max
          errors << [:too_long, count: max]
        end
      end

      def validate_minmax(value, min:, max:)
        # maybe acts_like?(:date) || acts_like?(:time)
        if min && value < min
          formatted =
            if min.respond_to?(:strftime) && defined?(I18n) && I18n.respond_to?(:l)
              I18n.l(min)
            else
              min
            end
          errors << [:greater_than_or_equal_to, count: formatted]
        end

        if max && value > max
          formatted =
            if max.respond_to?(:strftime) && defined?(I18n) && I18n.respond_to?(:l)
              I18n.l(max)
            else
              max
            end
          errors << [:less_than_or_equal_to, count: formatted]
        end
      end
    end
  end
end
