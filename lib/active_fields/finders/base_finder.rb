# frozen_string_literal: true

module ActiveFields
  module Finders
    class BaseFinder
      class << self
        def operation(name, operators:, &block)
          __operations__[name.to_sym] = operators.map(&:to_s)

          __operations__[name.to_sym].each do |operator|
            __operators__[operator] = block
          end
        end

        def operators_for(operation_name)
          __operations__[operation_name.to_sym]
        end

        def operation_for(operator)
          __operations__.find { |_operation_name, operators| operators.include?(operator.to_s) }.first
        end

        def operations
          __operations__.keys
        end

        def __operations__
          @__operations__ ||= {}
        end

        def __operators__
          @__operators__ ||= {}
        end
      end

      attr_reader :active_field

      def initialize(active_field:)
        @active_field = active_field
      end

      def search(operator:, value:)
        operator = operator.to_s

        unless self.class.__operators__.key?(operator)
          raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{self.class.name}`"
        end

        instance_exec(value, &self.class.__operators__[operator])
      end

      private

      def cte_name = ActiveFields.config.value_class.table_name

      def scope
        ActiveFields.config.value_class.with(cte_name => active_field.active_values)
      end
    end
  end
end
