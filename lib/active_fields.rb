# frozen_string_literal: true

require_relative "active_fields/version"
require_relative "active_fields/constants"
require_relative "active_fields/engine"

module ActiveFields
  extend ActiveSupport::Autoload

  class << self
    def eager_load!
      super
      Casters.eager_load!
      Validators.eager_load!
    end
  end

  eager_autoload do
    autoload :Config
    autoload :CustomizableConfig
    autoload :HasActiveFields
  end

  module Casters
    extend ActiveSupport::Autoload

    eager_autoload do
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
  end

  module Validators
    extend ActiveSupport::Autoload

    eager_autoload do
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
  end

  class << self
    def config
      yield Config.instance if block_given?
      Config.instance
    end

    alias_method :configure, :config
  end
end
