# frozen_string_literal: true

module ActiveFields
  # Model mix-in with a base logic for the active fields model
  module FieldConcern
    extend ActiveSupport::Concern

    included do
      has_many :active_values,
        class_name: ActiveFields.config.value_class_name,
        foreign_key: :active_field_id,
        inverse_of: :active_field,
        dependent: :destroy

      # If an active field's scope is nil, it will be available to all records of the given customizable type,
      # regardless of any scope restrictions defined for the customizable model.
      scope :for, ->(customizable_type, scope: nil) do
        where(customizable_type: customizable_type, scope: [scope, nil].uniq)
      end

      validates :type, presence: true
      validates :name, presence: true
      validate :validate_name_uniqueness
      validate :validate_default_value
      validate :validate_customizable_model_allows_type

      after_initialize :set_defaults
      before_validation :set_scope
    end

    class_methods do
      def acts_as_active_field(array: false, validator:, caster:, finder: {})
        include FieldArrayConcern if array

        define_method(:array?) { array }

        define_method(:value_validator_class) do
          @value_validator_class ||= validator[:class_name].constantize
        end

        define_method(:value_validator) do
          options =
            if validator[:options].nil?
              {}
            elsif validator[:options].arity == 0
              instance_exec(&validator[:options])
            else
              validator[:options].call(self)
            end
          value_validator_class.new(**options)
        end

        define_method(:value_caster_class) do
          @value_caster_class ||= caster[:class_name].constantize
        end

        define_method(:value_caster) do
          options =
            if caster[:options].nil?
              {}
            elsif caster[:options].arity == 0
              instance_exec(&caster[:options])
            else
              caster[:options].call(self)
            end
          value_caster_class.new(**options)
        end

        define_method(:value_finder_class) do
          @value_finder_class ||= finder[:class_name]&.constantize
        end

        define_method(:value_finder) do
          value_finder_class&.new(active_field: self)
        end
      end
    end

    def customizable_model
      customizable_type.safe_constantize
    end

    def default_value=(v)
      default_value_meta["const"] = value_caster.serialize(v)
    end

    def default_value
      value_caster.deserialize(default_value_meta["const"])
    end

    def type_name
      ActiveFields.config.fields.key(type)
    end

    # Returns customizable types that allow this field type.
    #
    # NOTE:
    # - The customizable model must be loaded to appear in this list.
    #   Relationships between customizable models and field types are established in the `has_active_fields` method,
    #   which is typically called within the customizable model.
    #   If eager loading is enabled, there should be no issues.
    #   However, if eager loading is disabled (common in development),
    #   the list will remain incomplete until all customizable models are loaded.
    # - Code reloading may behave incorrectly at times.
    #   Restart your application if you make changes to the allowed types list in `has_active_fields`.
    def available_customizable_types
      ActiveFields.registry.customizable_types_for(type_name).to_a
    end

    private

    # NOTE: The uniqueness constraint in the DB does not fully enforce this validation:
    # Records where scope is NULL do not prevent the existence of records with the same
    # [name, customizable_type] but with a non-NULL scope, and vice versa.
    def validate_name_uniqueness
      base_scope =
        ActiveFields.config.field_base_class.excluding(self).where(customizable_type: customizable_type, name: name)

      if scope.nil?
        if base_scope.exists?
          errors.add(:name, :taken)
          return false
        end
      elsif base_scope.exists?(scope: [scope, nil])
        errors.add(:name, :taken)
        return false
      end

      true
    end

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
      allowed_type_names = ActiveFields.registry.field_type_names_for(customizable_type).to_a
      return true if allowed_type_names.include?(type_name)

      errors.add(:customizable_type, :inclusion)
      false
    end

    def set_defaults; end

    # Forces scope to nil if the customizable model does not have a scope method.
    def set_scope
      return if customizable_model.nil?

      self.scope = nil if customizable_model.active_fields_scope_method.nil?
    end
  end
end
