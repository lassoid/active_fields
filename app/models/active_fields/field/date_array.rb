# frozen_string_literal: true

module ActiveFields
  module Field
    class DateArray < ActiveFields.config.field_base_class
      store_accessor :options, :min_size, :max_size, :min, :max

      # attribute :min_size, :integer
      # attribute :max_size, :integer
      # attribute :min, :date
      # attribute :max, :date

      validates :min_size, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true
      validates :max_size, comparison: { greater_than_or_equal_to: ->(r) { r.min_size || 0 } }, allow_nil: true
      validates :max, comparison: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min

      %i[min_size max_size].each do |column|
        define_method(column) do
          Casters::IntegerCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::IntegerCaster.new(nil).serialize(other))
        end
      end

      %i[min max].each do |column|
        define_method(column) do
          Casters::DateCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::DateCaster.new(nil).serialize(other))
        end
      end

      private

      def set_defaults; end
    end
  end
end
