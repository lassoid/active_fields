# frozen_string_literal: true

require_relative "../field"

module ActiveFields
  class Field
    class DecimalArray < ActiveFields::Field
      store_accessor :options, :min, :max, :min_size, :max_size

      # attribute :min, :decimal
      # attribute :max, :decimal
      # attribute :min_size, :integer
      # attribute :max_size, :integer

      validates :max, comparison: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min
      validates :min_size, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true
      validates :max_size, comparison: { greater_than_or_equal_to: ->(r) { r.min_size || 0 } }, allow_nil: true

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
