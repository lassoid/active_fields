# frozen_string_literal: true

module ActiveFields
  module Finders
    class BaseFinder
      attr_reader :active_field

      def initialize(active_field:)
        @active_field = active_field
      end

      def search(operator:, value:)
        raise NotImplementedError
      end

      private

      def cte_name = ActiveFields.config.value_class.table_name

      def scope
        ActiveFields.config.value_class.with(cte_name => active_field.active_values)
      end

      def operator_not_found!(operator)
        raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{self.class.name}`"
      end
    end
  end
end
