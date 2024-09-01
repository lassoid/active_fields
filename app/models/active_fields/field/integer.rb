# frozen_string_literal: true

module ActiveFields
  module Field
    class Integer < ActiveFields.config.field_base_class
      acts_as_active_field(
        validator: {
          class_name: "ActiveFields::Validators::IntegerValidator",
          options: -> { { required: required?, min: min, max: max } },
        },
        caster: {
          class_name: "ActiveFields::Casters::IntegerCaster",
          options: -> { {} },
        },
      )

      store_accessor :options, :required, :min, :max

      validates :required, exclusion: [nil]
      validates :max, comparison: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min

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
    end
  end
end
