# frozen_string_literal: true

module ActiveFields
  # Storage for configured relations between active fields and customizable models
  class Registry
    include Singleton

    def initialize
      @fields = {}
      @customizables = {}
    end

    def add(field_type_name, customizable_type)
      if ActiveFields.config.type_names.exclude?(field_type_name)
        raise ArgumentError, "undefined ActiveFields type provided for #{customizable_type}: #{field_type_name}"
      end

      @fields[field_type_name] ||= Set.new
      @fields[field_type_name] << customizable_type

      @customizables[customizable_type] ||= Set.new
      @customizables[customizable_type] << field_type_name

      nil
    end

    def customizable_types_for(field_type_name)
      @fields[field_type_name]
    end

    def field_type_names_for(customizable_type)
      @customizables[customizable_type]
    end
  end
end
