# frozen_string_literal: true

require_relative "../field"

module ActiveFields
  class Field
    class Integer < ActiveFields::Field
      store_accessor :options, :required, :min, :max

      # attribute :required, :boolean, default: false
      # attribute :min, :integer
      # attribute :max, :integer

      validates :required, exclusion: [nil]
      validates :max, numericality: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min

      %i[required].each do |column|
        define_method(column) do
          ActiveFields::Casters::BooleanCaster.new.deserialize(super())
        end

        define_method(:"#{column}?") do
          !!public_send(column)
        end

        define_method(:"#{column}=") do |other|
          super(ActiveFields::Casters::BooleanCaster.new.serialize(other))
        end
      end

      %i[min max].each do |column|
        define_method(column) do
          ActiveFields::Casters::IntegerCaster.new.deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(ActiveFields::Casters::IntegerCaster.new.serialize(other))
        end
      end

      private

      def set_defaults
        self.required ||= false
      end
    end
  end
end
