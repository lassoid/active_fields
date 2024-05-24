# frozen_string_literal: true

require "active_support"

require_relative "active_fields/version"
require_relative "active_fields/config"

module ActiveFields
  autoload :CustomizableConfig, "active_fields/customizable_config"
  autoload :ModelConcern, "active_fields/models/concerns/model_concern"
  autoload :CustomizableConcern, "active_fields/models/concerns/customizable_concern"
  autoload :FieldConcern, "active_fields/models/concerns/field_concern"
  autoload :ValueConcern, "active_fields/models/concerns/value_concern"
  autoload :Value, "active_fields/models/value"

  module Field
    autoload :Base, "active_fields/models/field/base"
    autoload :Boolean, "active_fields/models/field/boolean"
    autoload :Date, "active_fields/models/field/date"
    autoload :DateArray, "active_fields/models/field/date_array"
    autoload :Decimal, "active_fields/models/field/decimal"
    autoload :DecimalArray, "active_fields/models/field/decimal_array"
    autoload :Enum, "active_fields/models/field/enum"
    autoload :EnumArray, "active_fields/models/field/enum_array"
    autoload :Integer, "active_fields/models/field/integer"
    autoload :IntegerArray, "active_fields/models/field/integer_array"
    autoload :Text, "active_fields/models/field/text"
    autoload :TextArray, "active_fields/models/field/text_array"
  end

  module Casters
    autoload :BaseCaster, "active_fields/casters/base_caster"
    autoload :BooleanCaster, "active_fields/casters/boolean_caster"
    autoload :DateCaster, "active_fields/casters/date_caster"
    autoload :DateArrayCaster, "active_fields/casters/date_array_caster"
    autoload :DecimalCaster, "active_fields/casters/decimal_caster"
    autoload :DecimalArrayCaster, "active_fields/casters/decimal_array_caster"
    autoload :EnumCaster, "active_fields/casters/enum_caster"
    autoload :EnumArrayCaster, "active_fields/casters/enum_array_caster"
    autoload :IntegerCaster, "active_fields/casters/integer_caster"
    autoload :IntegerArrayCaster, "active_fields/casters/integer_array_caster"
    autoload :TextCaster, "active_fields/casters/text_caster"
    autoload :TextArrayCaster, "active_fields/casters/text_array_caster"
  end

  module Validators
    autoload :BaseValidator, "active_fields/validators/base_validator"
    autoload :BooleanValidator, "active_fields/validators/boolean_validator"
    autoload :DateValidator, "active_fields/validators/date_validator"
    autoload :DateArrayValidator, "active_fields/validators/date_array_validator"
    autoload :DecimalValidator, "active_fields/validators/decimal_validator"
    autoload :DecimalArrayValidator, "active_fields/validators/decimal_array_validator"
    autoload :EnumValidator, "active_fields/validators/enum_validator"
    autoload :EnumArrayValidator, "active_fields/validators/enum_array_validator"
    autoload :IntegerValidator, "active_fields/validators/integer_validator"
    autoload :IntegerArrayValidator, "active_fields/validators/integer_array_validator"
    autoload :TextValidator, "active_fields/validators/text_validator"
    autoload :TextArrayValidator, "active_fields/validators/text_array_validator"
  end

  class << self
    def config
      yield Config.instance if block_given?
      Config.instance
    end

    alias_method :configure, :config
  end
end

if defined?(Rails)
  ActiveSupport.on_load(:active_record) do
    include ActiveFields::ModelConcern
  end
else
  require "active_record"

  # rubocop:disable Rails/ActiveSupportOnLoad
  ActiveRecord::Base.include ActiveFields::ModelConcern
  # rubocop:enable Rails/ActiveSupportOnLoad
end
