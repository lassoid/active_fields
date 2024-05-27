# frozen_string_literal: true

module ActiveFields
  # Mix-in that allows ActiveRecord models to enable active fields
  module ModelConcern
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :active_fields_config

      def has_active_fields(types: ActiveFields.config.fields.keys)
        include CustomizableConcern

        @active_fields_config = CustomizableConfig.new(self)
        @active_fields_config.types = types
      end
    end
  end
end
