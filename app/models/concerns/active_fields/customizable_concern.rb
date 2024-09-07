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

    # Assigns the given attributes to the active_values association.
    #
    # Accepts an Array of Hashes (symbol/string keys) or permitted params.
    # Each element should contain a <tt>:name</tt> key matching an existing active_field record.
    # Element with a <tt>:value</tt> key will create an active_value if it doesn't exist
    # or update an existing active_value, with the provided value.
    # Element with a <tt>:_destroy</tt> key set to a truthy value will mark the
    # matched active_value for destruction.
    #
    # Example:
    #
    #   customizable.active_fields_attributes = [
    #     { name: "integer_array", value: [1, 4, 5, 5, 0] }, # create or update (symbol keys)
    #     { "name" => "text", "value" => "Lasso" }, # create or update (string keys)
    #     { name: "date", _destroy: true }, # destroy (symbol keys)
    #     { "name" => "boolean", "_destroy" => true }, # destroy (string keys)
    #     permitted_params, # params could be passed, but they must be permitted
    #   ]
    def active_fields_attributes=(attributes)
      attributes = attributes.to_h if attributes.respond_to?(:permitted?)

      unless attributes.is_a?(Array) || attributes.is_a?(Hash)
        raise ArgumentError, "Array or Hash expected for `active_fields=`, got #{attributes.class.name}"
      end

      # Handle `fields_for` params
      attributes = attributes.values if attributes.is_a?(Hash)

      active_fields_by_name = active_fields.index_by(&:name)
      active_values_by_field_id = active_values.index_by(&:active_field_id)

      nested_attributes = attributes.filter_map do |active_value_attributes|
        # Convert params to Hash
        active_value_attributes = active_value_attributes.to_h if active_value_attributes.respond_to?(:permitted?)
        active_value_attributes = active_value_attributes.with_indifferent_access

        active_field = active_fields_by_name[active_value_attributes[:name]]
        next if active_field.nil?

        active_value = active_values_by_field_id[active_field.id]

        if has_destroy_flag?(active_value_attributes)
          # Destroy
          { id: active_value&.id, _destroy: true }
        elsif active_value
          # Update
          { id: active_value.id, value: active_value_attributes[:value] }
        else
          # Create
          { active_field: active_field, value: active_value_attributes[:value] }
        end
      end

      self.active_values_attributes = nested_attributes
    end

    alias_method :active_fields=, :active_fields_attributes=

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
