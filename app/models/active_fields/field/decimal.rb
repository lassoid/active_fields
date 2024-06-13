# frozen_string_literal: true

module ActiveFields
  module Field
    class Decimal < ActiveFields.config.field_base_class
      store_accessor :options, :required, :min, :max

      # attribute :required, :boolean, default: false
      # attribute :min, :decimal
      # attribute :max, :decimal

      validates :required, exclusion: [nil]
      validates :max, comparison: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min

      %i[required].each do |column|
        define_method(column) do
          Casters::BooleanCaster.new.deserialize(super())
        end

        define_method(:"#{column}?") do
          !!public_send(column)
        end

        define_method(:"#{column}=") do |other|
          super(Casters::BooleanCaster.new.serialize(other))
        end
      end

      %i[min max].each do |column|
        define_method(column) do
          Casters::DecimalCaster.new.deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::DecimalCaster.new.serialize(other))
        end
      end

      private

      def set_defaults
        self.required ||= false
      end
    end
  end
end
