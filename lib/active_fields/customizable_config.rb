# frozen_string_literal: true

module ActiveFields
  class CustomizableConfig
    attr_reader :customizable_model, :types

    def initialize(customizable_model)
      @customizable_model = customizable_model
    end

    def types=(value)
      raise ArgumentError if (value - ActiveFields.config.fields.keys).any?

      @types = value
    end
  end
end
