# frozen_string_literal: true

require_relative "../field"

module ActiveFields
  class Field
    class Decimal < ActiveFields::Field
      store_accessor :options, :required, :min, :max

      # attribute :required, :boolean, default: false
      # attribute :min, :decimal
      # attribute :max, :decimal

      validates :required, exclusion: [nil]
      validates :max, numericality: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min

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

      %i[min max].each do |column|
        define_method(column) do
          ActiveModel::Type::Decimal.new.cast(super())
        end

        define_method("#{column}=") do |other|
          super(ActiveModel::Type::Decimal.new.cast(other))
        end
      end

      private

      def set_defaults
        self.required ||= false
      end
    end
  end
end
