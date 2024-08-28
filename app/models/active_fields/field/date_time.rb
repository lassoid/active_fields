# frozen_string_literal: true

module ActiveFields
  module Field
    class DateTime < ActiveFields.config.field_base_class
      store_accessor :options, :required, :min, :max, :precision

      validates :required, exclusion: [nil]
      validates :max, comparison: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min
      validates :precision, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true

      %i[required].each do |column|
        define_method(column) do
          Casters::BooleanCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}?") do
          !!public_send(column)
        end

        define_method(:"#{column}=") do |other|
          super(Casters::BooleanCaster.new(nil).serialize(other))
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

      %i[precision].each do |column|
        define_method(column) do
          Casters::IntegerCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::IntegerCaster.new(nil).serialize(other))
        end
      end

      private

      def set_defaults
        self.required ||= false
      end
    end
  end
end
