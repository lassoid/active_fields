# frozen_string_literal: true

require_relative "active_fields/version"
require_relative "active_fields/engine"

module ActiveFields
  extend ActiveSupport::Autoload

  autoload :Config
  autoload :CustomizableConfig
  autoload :HasActiveFields

  module Casters
    extend ActiveSupport::Autoload

    autoload :BaseCaster
    autoload :BooleanCaster
    autoload :DateCaster
    autoload :DateArrayCaster
    autoload :DateTimeCaster
    autoload :DateTimeArrayCaster
    autoload :DecimalCaster
    autoload :DecimalArrayCaster
    autoload :EnumCaster
    autoload :EnumArrayCaster
    autoload :IntegerCaster
    autoload :IntegerArrayCaster
    autoload :TextCaster
    autoload :TextArrayCaster
  end

  module Validators
    extend ActiveSupport::Autoload

    autoload :BaseValidator
    autoload :BooleanValidator
    autoload :DateValidator
    autoload :DateArrayValidator
    autoload :DateTimeValidator
    autoload :DateTimeArrayValidator
    autoload :DecimalValidator
    autoload :DecimalArrayValidator
    autoload :EnumValidator
    autoload :EnumArrayValidator
    autoload :IntegerValidator
    autoload :IntegerArrayValidator
    autoload :TextValidator
    autoload :TextArrayValidator
  end

  class << self
    def config
      yield Config.instance if block_given?
      Config.instance
    end

    alias_method :configure, :config
  end
end
