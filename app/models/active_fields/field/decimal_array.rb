# frozen_string_literal: true

module ActiveFields
  module Field
    class DecimalArray < ActiveFields.config.field_base_class
      store_accessor :options, :min_size, :max_size, :min, :max, :precision

      # attribute :min_size, :integer
      # attribute :max_size, :integer
      # attribute :min, :decimal
      # attribute :max, :decimal
      # attribute :precision, :integer

      validates :min_size, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true
      validates :max_size, comparison: { greater_than_or_equal_to: ->(r) { r.min_size || 0 } }, allow_nil: true
      validates :max, comparison: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min
      validates :precision, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true

      %i[min_size max_size precision].each do |column|
        define_method(column) do
          Casters::IntegerCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::IntegerCaster.new(nil).serialize(other))
        end
      end

      %i[min max].each do |column|
        define_method(column) do
          Casters::DecimalCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::DecimalCaster.new(nil).serialize(other))
        end
      end

      private

      def set_defaults; end
    end
  end
end
