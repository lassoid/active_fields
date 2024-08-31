# frozen_string_literal: true

module ActiveFields
  module Field
    class DateArray < ActiveFields.config.field_base_class
      active_field_config(
        array: true,
        validator: {
          class_name: "ActiveFields::Validators::DateArrayValidator",
          options: -> { { min: min, max: max, min_size: min_size, max_size: max_size } },
        },
        caster: {
          class_name: "ActiveFields::Casters::DateArrayCaster",
          options: -> { {} },
        },
      )

      store_accessor :options, :min, :max

      validates :max, comparison: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min

      %i[min max].each do |column|
        define_method(column) do
          Casters::DateCaster.new.deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::DateCaster.new.serialize(other))
        end
      end

      private

      def set_defaults; end
    end
  end
end
