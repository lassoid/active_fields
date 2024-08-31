# frozen_string_literal: true

module ActiveFields
  module Field
    class Decimal < ActiveFields.config.field_base_class
      active_field_config(
        validator: {
          class_name: "ActiveFields::Validators::DecimalValidator",
          options: -> { { required: required?, min: min, max: max } },
        },
        caster: {
          class_name: "ActiveFields::Casters::DecimalCaster",
          options: -> { { precision: precision } },
        },
      )

      store_accessor :options, :required, :min, :max, :precision

      validates :required, exclusion: [nil]
      validates :max, comparison: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min
      validates :precision, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true

      before_validation :reapply_precision

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
          Casters::DecimalCaster.new(precision: precision).deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::DecimalCaster.new(precision: precision).serialize(other))
        end
      end

      %i[precision].each do |column|
        define_method(column) do
          Casters::IntegerCaster.new.deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::IntegerCaster.new.serialize(other))
        end
      end

      private

      def set_defaults
        self.required ||= false
      end

      def reapply_precision
        self.min = min
        self.max = max
        self.default_value = default_value
      end
    end
  end
end
