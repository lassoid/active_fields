# frozen_string_literal: true

module ActiveFields
  # Model mix-in that adds the active fields functionality to the customizable model
  module CustomizableConcern
    extend ActiveSupport::Concern

    included do
      # rubocop:disable Rails/ReflectionClassName
      has_many :active_values,
        class_name: ActiveFields.config.value_class_name,
        as: :customizable,
        inverse_of: :customizable,
        autosave: true,
        dependent: :destroy
      # rubocop:enable Rails/ReflectionClassName

      # Firstly, we build active_values that doesn't exist.
      # Than, we set values for active_values whose values should be changed
      # according to `active_values_attributes`.
      before_validation :initialize_active_values

      # This virtual attribute is used for setting active_values values.
      # Keys are active_fields names,
      # values are values for corresponding active_values of the record.
      attr_reader :active_values_attributes
    end

    def active_fields
      ActiveFields.config.field_base_class.for(model_name.name)
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

    def find_active_value_by_field(active_field)
      active_values.find { |active_value| active_value.active_field_id == active_field.id }
    end
  end
end
