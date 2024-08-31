# frozen_string_literal: true

module ActiveFields
  module Field
    class EnumArray < ActiveFields.config.field_base_class
      active_field_config(
        array: true,
        validator: {
          class_name: "ActiveFields::Validators::EnumArrayValidator",
          options: -> { { allowed_values: allowed_values, min_size: min_size, max_size: max_size } },
        },
        caster: {
          class_name: "ActiveFields::Casters::EnumArrayCaster",
          options: -> { {} },
        },
      )

      store_accessor :options, :allowed_values

      validate :validate_allowed_values

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
        self.allowed_values ||= []
      end
    end
  end
end
