# frozen_string_literal: true

module ActiveFields
  # Mix-in that adds the active fields functionality to the ActiveRecord model
  module CustomizableConcern
    extend ActiveSupport::Concern

    included do
      # active_values association for the owner record.
      # We skip built-in autosave because it doesn't work if the owner record isn't changed.
      # Instead, we implement our own autosave callback: `save_changed_active_values`.
      # rubocop:disable Rails/ReflectionClassName
      has_many :active_values,
        class_name: ActiveFields.config.value_class,
        as: :customizable,
        inverse_of: :customizable,
        autosave: false,
        dependent: :destroy
      # rubocop:enable Rails/ReflectionClassName

      # Firstly, we build active_values that hasn't been already created.
      # Than, we set values for active_values whose values should be changed
      # according to `active_values_attributes`.
      before_validation :initialize_active_values

      # Save all changed active_values on the owner record save.
      after_save :save_changed_active_values

      # We always validate active_values on the owner record change,
      # as if they are just an ordinary record columns.
      validates_associated :active_values

      # This virtual attribute is used for setting active_values values.
      # Keys are active_fields names,
      # values are values for corresponding active_values of the record.
      attr_reader :active_values_attributes
    end

    def active_fields
      ActiveFields.config.field_model.for(model_name.name)
    end

    # Convert hash keys to strings for easier access by fields names.
    def active_values_attributes=(value)
      @active_values_attributes =
        if value.respond_to?(:to_h)
          value.to_h.transform_keys(&:to_s)
        else
          value
        end
    end

    private

    def initialize_active_values
      active_fields.each do |active_field|
        active_value =
          find_active_value_by_field(active_field) ||
          active_values.new(active_field: active_field, value: active_field.default_value)

        next unless active_values_attributes.is_a?(Hash)
        next unless active_values_attributes.key?(active_field.name)

        active_value.value = active_values_attributes[active_field.name]
      end
    end

    def save_changed_active_values
      active_values.each do |active_value|
        next unless active_value.new_record? || active_value.changed?

        # For new records association id isn't set right, so we force reassignment of the customizable
        active_value.customizable = self

        # Do not validate active values twice,
        # because they have already been validated by `validates_associated`.
        active_value.save!(validate: false)
      end
    end

    def find_active_value_by_field(active_field)
      active_values.find { |active_value| active_value.active_field_id == active_field.id }
    end
  end
end
