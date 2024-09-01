# frozen_string_literal: true

module ActiveFields
  module Field
    class IntegerArray < ActiveFields.config.field_base_class
      acts_as_active_field(
        array: true,
        validator: {
          class_name: "ActiveFields::Validators::IntegerArrayValidator",
          options: -> { { min: min, max: max, min_size: min_size, max_size: max_size } },
        },
        caster: {
          class_name: "ActiveFields::Casters::IntegerArrayCaster",
        },
      )

      store_accessor :options, :min, :max

      validates :max, comparison: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min

      %i[min max].each do |column|
        define_method(column) do
          Casters::IntegerCaster.new.deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::IntegerCaster.new.serialize(other))
        end
      end

      private

      def set_defaults; end
    end
  end
end
