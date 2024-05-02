# frozen_string_literal: true

require_relative "../field"

module ActiveFields
  class Field
    class EnumArray < ActiveFields::Field
      store_accessor :options, :min_size, :max_size, :allowed_values

      # attribute :min_size, :integer
      # attribute :max_size, :integer
      # attribute :allowed_values, :string, array: true, default: []

      validates :min_size, numericality: { greater_than_or_equal_to: 0 }
      validates :max_size, numericality: { greater_than_or_equal_to: ->(r) { r.min_size || 0 } }, allow_nil: true
      validate :validate_allowed_values

      %i[min_size max_size].each do |column|
        define_method(column) do
          ActiveFields::Casters::IntegerCaster.new.deserialize(super())
        end

        define_method("#{column}=") do |other|
          super(ActiveFields::Casters::IntegerCaster.new.serialize(other))
        end
      end

      %i[allowed_values].each do |column|
        define_method(column) do
          ActiveFields::Casters::TextArrayCaster.new.deserialize(super())
        end

        define_method("#{column}=") do |other|
          super(ActiveFields::Casters::TextArrayCaster.new.serialize(other))
        end
      end

      private

      def validate_allowed_values
        if allowed_values.nil?
          errors.add(:allowed_values, :blank)
        elsif allowed_values.is_a?(Array)
          if allowed_values.empty?
            errors.add(:allowed_values, :blank)
          elsif allowed_values.any?(&:blank?)
            errors.add(:allowed_values, :blank)
          end
        else
          errors.add(:allowed_values, :invalid)
        end
      end

      def set_defaults
        self.allowed_values ||= []
      end
    end
  end
end
