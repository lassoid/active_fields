# frozen_string_literal: true

module ActiveFields
  # Storage for configured relations between active fields and customizable models
  class Registry
    include Singleton

    def initialize
      @fields = {}
      @customizables = {}
    end

    def add(field_type, customizable_type)
      if ActiveFields.config.type_names.exclude?(field_type)
        raise ArgumentError, "undefined ActiveFields type provided for #{customizable_type}: #{field_type}"
      end

      @fields[field_type] ||= Set.new
      @fields[field_type] << customizable_type

      @customizables[customizable_type] ||= Set.new
      @customizables[customizable_type] << field_type

      nil
    end

    def customizable_types_for(field_type)
      @fields[field_type]
    end

    def field_types_for(customizable_type)
      @customizables[customizable_type]
    end
  end
end
