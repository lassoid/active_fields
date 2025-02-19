# frozen_string_literal: true

module ActiveFields
  module Field
    class Date < ActiveFields.config.field_base_class
      acts_as_active_field(
        validator: {
          class_name: "ActiveFields::Validators::DateValidator",
          options: -> { { required: required?, min: min, max: max } },
        },
        caster: {
          class_name: "ActiveFields::Casters::DateCaster",
        },
        finder: {
          class_name: "ActiveFields::Finders::DateFinder",
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
          Casters::DateCaster.new.deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::DateCaster.new.serialize(other))
        end
      end

      private

      def set_defaults
        self.required ||= false
      end
    end
  end
end
