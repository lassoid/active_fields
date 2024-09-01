# frozen_string_literal: true

module ActiveFields
  module Field
    class DecimalArray < ActiveFields.config.field_base_class
      acts_as_active_field(
        array: true,
        validator: {
          class_name: "ActiveFields::Validators::DecimalArrayValidator",
          options: -> { { min: min, max: max, min_size: min_size, max_size: max_size } },
        },
        caster: {
          class_name: "ActiveFields::Casters::DecimalArrayCaster",
          options: -> { { precision: precision } },
        },
      )

      store_accessor :options, :min, :max, :precision

      validates :max, comparison: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min
      validates :precision, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true

      before_validation :reapply_precision

      %i[precision].each do |column|
        define_method(column) do
          Casters::IntegerCaster.new.deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::IntegerCaster.new.serialize(other))
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

      private

      def set_defaults; end

      def reapply_precision
        self.min = min
        self.max = max
        self.default_value = default_value
      end
    end
  end
end
