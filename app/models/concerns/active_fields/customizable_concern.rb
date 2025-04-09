# frozen_string_literal: true

module ActiveFields
  # Model mix-in that adds the active fields functionality to the customizable model
  module CustomizableConcern
    extend ActiveSupport::Concern

    included do
      has_many :active_values,
        class_name: ActiveFields.config.value_class_name,
        as: :customizable,
        inverse_of: :customizable,
        autosave: true,
        dependent: :destroy

      # Searches customizables by active_values.
      #
      # Accepts an Array of Hashes (symbol/string keys),
      # a Hash of Hashes generated from HTTP/HTML parameters
      # or permitted params.
      # Each element should contain:
      # - <tt>:n</tt> or <tt>:name</tt> key matching the active_field record name;
      # - <tt>:op</tt> or <tt>:operator</tt> key specifying search operation or operator;
      # - <tt>:v</tt> or <tt>:value</tt> key specifying search value.
      #
      # Example:
      #
      #   # Array of hashes
      #   CustomizableModel.where_active_fields(
      #     [
      #       { name: "integer_array", operator: "any_gteq", value: 5 }, # symbol keys
      #       { "name" => "text", operator: "=", "value" => "Lasso" }, # string keys
      #       { n: "boolean", op: "!=", v: false }, # compact form (string or symbol keys)
      #     ],
      #   )
      #
      #   # Hash of hashes generated from HTTP/HTML parameters
      #   CustomizableModel.where_active_fields(
      #     {
      #       "0" => { name: "integer_array", operator: "any_gteq", value: 5 },
      #       "1" => { "name" => "text", operator: "=", "value" => "Lasso" },
      #       "2" => { n: "boolean", op: "!=", v: false },
      #     },
      #   )
      #
      #   # Params (must be permitted)
      #   CustomizableModel.where_active_fields(permitted_params)
      scope :where_active_fields, ->(filters) do
        filters = filters.to_h if filters.respond_to?(:permitted?)

        unless filters.is_a?(Array) || filters.is_a?(Hash)
          raise ArgumentError, "Hash or Array expected for `where_active_fields`, got #{filters.class.name}"
        end

        # Handle `fields_for` params
        filters = filters.values if filters.is_a?(Hash)

        active_fields_by_name = active_fields.index_by(&:name)

        filters.inject(self) do |scope, filter|
          filter = filter.to_h if filter.respond_to?(:permitted?)
          filter = filter.with_indifferent_access

          active_field = active_fields_by_name[filter[:n] || filter[:name]]
          next scope if active_field.nil?
          next scope if active_field.value_finder.nil?

          active_values = active_field.value_finder.search(
            op: filter[:op] || filter[:operator],
            value: filter[:v] || filter[:value],
          )
          next scope if active_values.nil?

          scope.where(id: active_values.select(:customizable_id))
        end
      end

      accepts_nested_attributes_for :active_values, allow_destroy: true
    end

    class_methods do
      # Collection of active fields registered for this customizable
      def active_fields
        ActiveFields.config.field_base_class.for(name)
      end

      # Returns active fields type names allowed for this customizable model.
      def allowed_active_fields_type_names
        ActiveFields.registry.field_type_names_for(name).to_a
      end

      # Returns active fields class names allowed for this customizable model.
      def allowed_active_fields_class_names
        ActiveFields.config.fields.values_at(*allowed_active_fields_type_names)
      end
    end

    delegate :active_fields, to: :class

    # Assigns the given attributes to the active_values association.
    #
    # Accepts an Array of Hashes (symbol/string keys),
    # a Hash of Hashes generated from HTTP/HTML parameters
    # or permitted params.
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
    #
    #   customizable.active_fields_attributes = {
    #     "0" => { name: "integer_array", value: [1, 4, 5, 5, 0] }, # create or update (symbol keys)
    #     "1" => { "name" => "text", "value" => "Lasso" }, # create or update (string keys)
    #     "2" => { name: "date", _destroy: true }, # destroy (symbol keys)
    #     "3" => { "name" => "boolean", "_destroy" => true }, # destroy (string keys)
    #   }
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

    # Build an active_value, if it doesn't exist, with a default value for each available active_field.
    # Returns active_values collection.
    def initialize_active_values
      existing_field_ids = active_values.map(&:active_field_id)

      active_fields.each do |active_field|
        next if existing_field_ids.include?(active_field.id)

        active_values.new(active_field: active_field, value: active_field.default_value)
      end

      active_values
    end
  end
end
