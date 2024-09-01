# frozen_string_literal: true

module ActiveFields
  module Field
    class Enum < ActiveFields.config.field_base_class
      acts_as_active_field(
        validator: {
          class_name: "ActiveFields::Validators::EnumValidator",
          options: -> { { required: required?, allowed_values: allowed_values } },
        },
        caster: {
          class_name: "ActiveFields::Casters::EnumCaster",
          options: -> { {} },
        },
      )

      store_accessor :options, :required, :allowed_values

      validates :required, exclusion: [nil]
      validate :validate_allowed_values

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

      %i[allowed_values].each do |column|
        define_method(column) do
          Casters::TextArrayCaster.new.deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::TextArrayCaster.new.serialize(other))
        end
      end

      private

      def validate_allowed_values
        if allowed_values.nil?
          errors.add(:allowed_values, :blank)
          return false
        end

        unless allowed_values.is_a?(Array)
          errors.add(:allowed_values, :invalid)
          return false
        end

        if allowed_values.empty?
          errors.add(:allowed_values, :blank)
          return false
        end

        allowed_values.each do |value_element|
          if value_element.blank?
            errors.add(:allowed_values, :invalid)
            return false
          end
        end

        true
      end

      def set_defaults
        self.required ||= false
        self.allowed_values ||= []
      end
    end
  end
end
