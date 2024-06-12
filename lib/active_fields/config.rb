# frozen_string_literal: true

module ActiveFields
  class Config
    DEFAULT_FIELD_BASE_CLASS = "ActiveFields::Field::Base"
    DEFAULT_VALUE_CLASS = "ActiveFields::Value"

    include Singleton

    attr_accessor :field_base_class, :value_class, :fields

    def initialize
      @field_base_class = DEFAULT_FIELD_BASE_CLASS
      @value_class = DEFAULT_VALUE_CLASS
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

    def field_base_model
      @field_base_model ||= field_base_class.constantize
    end

    def value_model
      @value_model ||= value_class.constantize
    end

    def field_base_class_changed?
      field_base_class != DEFAULT_FIELD_BASE_CLASS
    end

    def value_class_changed?
      value_class != DEFAULT_VALUE_CLASS
    end

    def register_field(type_name, class_name)
      @fields[type_name.to_sym] = class_name
    end
  end
end
