# frozen_string_literal: true

module ActiveFields
  class CustomizableConfig
    attr_reader :customizable_model, :types

    def initialize(customizable_model)
      @customizable_model = customizable_model
    end

    def types=(value)
      invalid_types = value - ActiveFields.config.fields.keys
      if invalid_types.any?
        raise ArgumentError, "undefined ActiveFields types provided for #{customizable_model}: #{invalid_types}"
      end

      @types = value
    end
  end
end
