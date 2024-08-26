# frozen_string_literal: true

module ActiveFields
  class Config
    DEFAULT_FIELD_BASE_CLASS_NAME = "ActiveFields::Field::Base"
    DEFAULT_VALUE_CLASS_NAME = "ActiveFields::Value"

    include Singleton

    attr_accessor :field_base_class_name, :value_class_name
    attr_reader :fields

    def initialize
      @field_base_class_name = DEFAULT_FIELD_BASE_CLASS_NAME
      @value_class_name = DEFAULT_VALUE_CLASS_NAME
      @fields = {
        boolean: "ActiveFields::Field::Boolean",
        date: "ActiveFields::Field::Date",
        date_array: "ActiveFields::Field::DateArray",
        decimal: "ActiveFields::Field::Decimal",
        decimal_array: "ActiveFields::Field::DecimalArray",
        enum: "ActiveFields::Field::Enum",
        enum_array: "ActiveFields::Field::EnumArray",
        integer: "ActiveFields::Field::Integer",
        integer_array: "ActiveFields::Field::IntegerArray",
        text: "ActiveFields::Field::Text",
        text_array: "ActiveFields::Field::TextArray",
      }
    end

    def field_base_class
      @field_base_class ||= field_base_class_name.constantize
    end

    def value_class
      @value_class ||= value_class_name.constantize
    end

    def field_base_class_changed?
      field_base_class_name != DEFAULT_FIELD_BASE_CLASS_NAME
    end

    def value_class_changed?
      value_class_name != DEFAULT_VALUE_CLASS_NAME
    end

    def register_field(type_name, class_name)
      @fields[type_name.to_sym] = class_name
    end

    def type_names
      fields.keys
    end

    def type_class_names
      fields.values
    end
  end
end
