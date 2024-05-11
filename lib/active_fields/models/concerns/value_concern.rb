# frozen_string_literal: true

# Mix-in with a base logic for the active fields value model
module ActiveFields
  module ValueConcern
    extend ActiveSupport::Concern

    included do
      belongs_to :customizable, polymorphic: true, optional: false
      belongs_to :active_field, class_name: "ActiveFields::Field", optional: false

      validates :active_field_id, uniqueness: { scope: %i[customizable_id customizable_type] }
      validate :validate_value
      validate :validate_customizable_types_match
    end

    def value=(v)
      super(active_field&.value_caster&.serialize(v))
    end

    def value
      active_field&.value_caster&.deserialize(super)
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

    def validate_customizable_types_match
      return true if active_field.nil?
      return true if customizable_type == active_field.customizable_type

      errors.add(:customizable_type, :invalid)
      false
    end
  end
end
