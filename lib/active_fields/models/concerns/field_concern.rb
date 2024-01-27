# frozen_string_literal: true

# Mix-in with a base logic for the active fields definition model
module ActiveFields
  module FieldConcern
    extend ActiveSupport::Concern

    included do
      has_many :active_values, foreign_key: :active_field_id, inverse_of: :active_field, dependent: :destroy

      scope :for, ->(customizable_type) { where(customizable_type: customizable_type) }

      validates :type, presence: true
      validates :name, presence: true, uniqueness: { scope: :customizable_type }
      validates :name, format: { with: /\A[a-z0-9_]+\z/ }, allow_blank: true
      validate :validate_default_value

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
      customizable_type.constantize
    end

    def default_value=(v)
      super(field_caster.serialize(v))
    end

    def default_value
      field_caster.deserialize(super)
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

    def add_field_to_records
      customizable_model.all.find_each do |record|
        ActiveFields::Value.create!(active_field: self, customizable: record, value: default_value)
      end
    end

    def set_defaults; end
  end
end
