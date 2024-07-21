# frozen_string_literal: true

module ActiveFields
  # Mix-in with a base logic for the active fields model
  module FieldConcern
    extend ActiveSupport::Concern

    included do
      # rubocop:disable Rails/ReflectionClassName
      has_many :active_values,
        class_name: ActiveFields.config.value_class_name,
        foreign_key: :active_field_id,
        inverse_of: :active_field,
        dependent: :destroy
      # rubocop:enable Rails/ReflectionClassName

      scope :for, ->(customizable_type) { where(customizable_type: customizable_type) }

      validates :type, presence: true
      validates :name, presence: true, uniqueness: { scope: :customizable_type }
      validates :name, format: { with: /\A[a-z0-9_]+\z/ }, allow_blank: true
      validate :validate_default_value
      validate :validate_customizable_model_allows_type

      after_create :add_field_to_records
      after_initialize :set_defaults
    end

    def value_validator_class
      @value_validator_class ||= "ActiveFields::Validators::#{model_name.name.demodulize}Validator".constantize
    end

    def value_validator
      value_validator_class.new(self)
    end

    def value_caster_class
      @value_caster_class ||= "ActiveFields::Casters::#{model_name.name.demodulize}Caster".constantize
    end

    def value_caster
      value_caster_class.new(self)
    end

    def customizable_model
      customizable_type.safe_constantize
    end

    def default_value=(v)
      super(value_caster.serialize(v))
    end

    def default_value
      value_caster.deserialize(super)
    end

    private

    def validate_default_value
      validator = value_validator
      return if validator.validate(default_value)

      validator.errors.each do |error|
        if error.is_a?(Array) && error.size == 2 && error.first.is_a?(Symbol) && error.last.is_a?(Hash)
          errors.add(:default_value, error.first, **error.last)
        elsif error.is_a?(Symbol)
          errors.add(:default_value, *error)
        else
          raise ArgumentError
        end
      end
    end

    def validate_customizable_model_allows_type
      allowed_types = customizable_model&.active_fields_config&.types || []
      return true if ActiveFields.config.fields.values_at(*allowed_types).include?(type)

      errors.add(:customizable_type, :inclusion)
      false
    end

    def add_field_to_records
      customizable_model.find_each do |record|
        ActiveFields.config.value_class.create!(active_field: self, customizable: record, value: default_value)
      end
    end

    def set_defaults; end
  end
end
