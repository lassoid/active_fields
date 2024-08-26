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

      accepts_nested_attributes_for :active_values, allow_destroy: true
    end

    def active_fields
      ActiveFields.config.field_base_class.for(model_name.name)
    end

    # Build an active_value, if it doesn't exist, with a default value for each available active_field
    def initialize_active_values
      existing_field_ids = active_values.map(&:active_field_id)

      active_fields.each do |active_field|
        next if existing_field_ids.include?(active_field.id)

        active_values.new(active_field: active_field, value: active_field.default_value)
      end
    end
  end
end
