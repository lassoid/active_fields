# frozen_string_literal: true

module ActiveFields
  module Field
    class DateTimeArray < ActiveFields.config.field_base_class
      include FieldArrayConcern

      store_accessor :options, :min, :max, :precision

      validates :max, comparison: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min
      validates :precision, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true

      %i[precision].each do |column|
        define_method(column) do
          Casters::IntegerCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::IntegerCaster.new(nil).serialize(other))
        end
      end

      %i[min max].each do |column|
        define_method(column) do
          Casters::DateTimeCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::DateTimeCaster.new(nil).serialize(other))
        end
      end

      private

      def set_defaults; end
    end
  end
end
