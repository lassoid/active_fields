# frozen_string_literal: true

module ActiveFields
  module Field
    class Text < ActiveFields.config.field_base_class
      acts_as_active_field(
        validator: {
          class_name: "ActiveFields::Validators::TextValidator",
          options: -> { { required: required?, min_length: min_length, max_length: max_length } },
        },
        caster: {
          class_name: "ActiveFields::Casters::TextCaster",
        },
        finder: {
          class_name: "ActiveFields::Finders::TextFinder",
        },
      )

      store_accessor :options, :required, :min_length, :max_length

      validates :required, exclusion: [nil]
      validates :min_length, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true
      validates :max_length, comparison: { greater_than_or_equal_to: ->(r) { r.min_length || 0 } }, allow_nil: true

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

      %i[min_length max_length].each do |column|
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
