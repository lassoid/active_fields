# frozen_string_literal: true

module ActiveFields
  class Config
    include Singleton

    attr_accessor :field_class, :value_class, :fields

    def initialize
      @field_class = "ActiveFields::Field::Base"
      @value_class = "ActiveFields::Value"
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

    def field_model
      @field_model ||= field_class.constantize
    end

    def value_model
      @value_model ||= value_class.constantize
    end

    def register_field(type_name, class_name)
      @fields[type_name.to_sym] = class_name
    end
  end
end
