# frozen_string_literal: true

require_relative "../field"

module ActiveFields
  class Field
    class Enum < ActiveFields::Field
      store_accessor :options, :required, :allowed_values

      # attribute :required, :boolean, default: false
      # attribute :allowed_values, :string, array: true, default: []

      validates :required, exclusion: [nil]
      validate :validate_allowed_values

      %i[required].each do |column|
        define_method(column) do
          ActiveModel::Type::Boolean.new.cast(super())
        end

        define_method("#{column}?") do
          !!public_send(column)
        end

        define_method("#{column}=") do |other|
          super(ActiveModel::Type::Boolean.new.cast(other))
        end
      end

      %i[allowed_values].each do |column|
        define_method(column) do
          if super().is_a?(Array)
            super().map { |el| ActiveModel::Type::String.new.cast(el) }
          else
            nil
          end
        end

        define_method("#{column}=") do |other|
          if other.is_a?(Array)
            super(other.map { |el| ActiveModel::Type::String.new.cast(el) })
          else
            super(nil)
          end
        end
      end

      private

      def validate_allowed_values
        if allowed_values.nil?
          errors.add(:allowed_values, :blank)
        elsif allowed_values.is_a?(Array)
          if allowed_values.empty?
            errors.add(:allowed_values, :blank)
          elsif allowed_values.any(&:blank?)
            errors.add(:allowed_values, :blank)
          end
        else
          errors.add(:allowed_values, :invalid)
        end
      end

      def set_defaults
        self.required ||= false
        self.allowed_values ||= []
      end
    end
  end
end
