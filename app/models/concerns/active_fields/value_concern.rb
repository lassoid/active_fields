# frozen_string_literal: true

module ActiveFields
  # Model mix-in with a base logic for the active fields value model
  module ValueConcern
    extend ActiveSupport::Concern

    included do
      belongs_to :customizable, polymorphic: true, optional: false, inverse_of: :active_values
      # rubocop:disable Rails/ReflectionClassName
      belongs_to :active_field,
        class_name: ActiveFields.config.field_base_class_name,
        optional: false,
        inverse_of: :active_values
      # rubocop:enable Rails/ReflectionClassName

      validates :active_field, uniqueness: { scope: :customizable }
      validate :validate_value
      validate :validate_customizable_allowed

      before_validation :assign_value_from_temp, if: -> { temp_value && active_field }
    end

    attr_reader :temp_value

    def value=(v)
      if active_field
        clear_temp_value
        value_meta["const"] = active_field.value_caster.serialize(v)
      else
        assign_temp_value(v)
      end
    end

    def value
      return unless active_field

      if temp_value
        assign_value_from_temp
        value
      else
        active_field.value_caster.deserialize(value_meta["const"])
      end
    end

    private

    def validate_value
      return if (validator = active_field&.value_validator).nil?
      return if validator.validate(value)

      validator.errors.each do |error|
        if error.is_a?(Array) && error.size == 2 && error.first.is_a?(Symbol) && error.last.is_a?(Hash)
          errors.add(:value, error.first, **error.last)
        elsif error.is_a?(Symbol)
          errors.add(:value, *error)
        else
          raise ArgumentError
        end
      end
    end

    def validate_customizable_allowed
      return true if active_field.nil?
      return true if customizable_type == active_field.customizable_type

      errors.add(:customizable, :invalid)
      false
    end

    # Wrap the provided value to differentiate between explicitly setting it to nil and not setting it at all
    def assign_temp_value(v)
      @temp_value = { "value" => v }
    end

    def clear_temp_value
      @temp_value = nil
    end

    def assign_value_from_temp
      self.value = temp_value["value"]
      clear_temp_value
    end
  end
end
