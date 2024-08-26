# frozen_string_literal: true

module ActiveFields
  class CustomizableConfig
    attr_reader :customizable_model, :types

    def initialize(customizable_model)
      @customizable_model = customizable_model
    end

    def types=(value)
      invalid_types = value - ActiveFields.config.type_names
      if invalid_types.any?
        raise ArgumentError, "undefined ActiveFields types provided for #{customizable_model}: #{invalid_types}"
      end

      @types = value
    end

    def types_class_names
      ActiveFields.config.fields.values_at(*types)
    end
  end
end
