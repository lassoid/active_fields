# frozen_string_literal: true

module ActiveFields
  module Casters
    class DateTimeCaster < BaseCaster
      MAX_PRECISION = RUBY_VERSION >= "3.2" ? 9 : 6 # AR max precision is 6 for old Rubies

      def serialize(value)
        value = value.iso8601 if value.is_a?(Date)
        casted_value = caster.serialize(value)

        casted_value.iso8601(precision) if casted_value.acts_like?(:time)
      end

      def deserialize(value)
        value = value.iso8601 if value.is_a?(Date)
        casted_value = caster.deserialize(value)

        apply_precision(casted_value).in_time_zone if casted_value.acts_like?(:time)
      end

      private

      def caster
        ActiveRecord::Type::DateTime.new
      end

      # Use maximum precision by default to prevent the caster from truncating useful time information
      # before precision is applied later
      def precision
        [options[:precision], MAX_PRECISION].compact.min
      end

      def apply_precision(value)
        number_of_insignificant_digits = 9 - precision
        round_power = 10**number_of_insignificant_digits
        rounded_off_nsec = value.nsec % round_power

        value.change(nsec: value.nsec - rounded_off_nsec)
      end
    end
  end
end
