# frozen_string_literal: true

module ActiveFields
  module Finders
    class BaseFinder
      class << self
        # Define search operation
        def operation(name, operator:, &block)
          name = name.to_sym
          operator = operator.to_sym

          __operations__[name] = {
            operator: operator.to_sym,
            block: block,
          }
          __operators__[operator] = name
        end

        # Returns operator for provided search operation name
        def operator_for(operation_name)
          __operations__.dig(operation_name.to_sym, :operator)
        end

        # Returns search operation name for provided operator
        def operation_for(operator)
          __operators__[operator.to_sym]
        end

        # Returns all defined search operations names
        def operations
          __operations__.keys
        end

        # Storage for defined operations. Private.
        def __operations__
          @__operations__ ||= {}
        end

        # Index for finding operation by operator. Private.
        def __operators__
          @__operators__ ||= {}
        end
      end

      attr_reader :active_field

      def initialize(active_field:)
        @active_field = active_field
      end

      # Perform query operation
      # @param op [String, Symbol] Operation name or operator
      # @param value [Any] The value to search for
      def search(op:, value:)
        op = op.to_sym
        operation = self.class.__operations__.key?(op) ? op : self.class.__operators__[op]
        return if operation.nil?

        instance_exec(value, &self.class.__operations__[operation][:block])
      end

      private

      # Name of the CTE, that is used in queries. It is the original values table name.
      def cte_name = ActiveFields.config.value_class.table_name

      # Base scope for querying
      def scope
        ActiveFields.config.value_class.with(cte_name => active_field.active_values)
      end
    end
  end
end
