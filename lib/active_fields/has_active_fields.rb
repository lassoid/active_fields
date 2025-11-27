# frozen_string_literal: true

module ActiveFields
  # Mix-in that allows ActiveRecord models to enable active fields
  module HasActiveFields
    extend ActiveSupport::Concern

    class_methods do
      def has_active_fields(types: ActiveFields.config.type_names, scope_method: nil)
        include CustomizableConcern

        types.each do |field_type|
          ActiveFields.registry.add(field_type, name)
        end

        define_singleton_method(:active_fields_scope_method) { scope_method }
      end
    end
  end
end
