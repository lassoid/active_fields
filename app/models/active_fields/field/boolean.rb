# frozen_string_literal: true

module ActiveFields
  module Field
    class Boolean < ActiveFields.config.field_base_class
      acts_as_active_field(
        validator: {
          class_name: "ActiveFields::Validators::BooleanValidator",
          options: -> { { required: required?, nullable: nullable? } },
        },
        caster: {
          class_name: "ActiveFields::Casters::BooleanCaster",
          options: -> { {} },
        },
      )

      store_accessor :options, :required, :nullable

      validates :required, exclusion: [nil]
      validates :nullable, exclusion: [nil]

      %i[required nullable].each do |column|
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

      private

      def set_defaults
        self.required ||= false
        self.nullable ||= false
      end
    end
  end
end
