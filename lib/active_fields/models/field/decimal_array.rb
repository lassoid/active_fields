# frozen_string_literal: true

module ActiveFields
  module Field
    class DecimalArray < ActiveFields.config.field_model
      store_accessor :options, :min_size, :max_size, :min, :max

      # attribute :min_size, :integer
      # attribute :max_size, :integer
      # attribute :min, :decimal
      # attribute :max, :decimal

      validates :min_size, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true
      validates :max_size, comparison: { greater_than_or_equal_to: ->(r) { r.min_size || 0 } }, allow_nil: true
      validates :max, comparison: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min

      %i[min_size max_size].each do |column|
        define_method(column) do
          ActiveFields::Casters::IntegerCaster.new.deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(ActiveFields::Casters::IntegerCaster.new.serialize(other))
        end
      end

      %i[min max].each do |column|
        define_method(column) do
          ActiveFields::Casters::DecimalCaster.new.deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(ActiveFields::Casters::DecimalCaster.new.serialize(other))
        end
      end

      private

      def set_defaults; end
    end
  end
end
