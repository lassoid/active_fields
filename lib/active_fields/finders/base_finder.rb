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

      def active_values_cte
        ActiveFields.config.value_class.with(cte_name => active_field.active_values)
      end

      def value_field_jsonb
        Arel::Nodes::InfixOperation.new(
          "->",
          Arel::Table.new(cte_name)[:value_meta],
          Arel::Nodes.build_quoted("const"),
        )
      end

      def value_field_text
        Arel::Nodes::InfixOperation.new(
          "->>",
          Arel::Table.new(cte_name)[:value_meta],
          Arel::Nodes.build_quoted("const"),
        )
      end

      def casted_value_field(to)
        Arel::Nodes::NamedFunction.new("CAST", [value_field_text.as(to)])
      end

      def value_jsonb_path_exists(jsonpath, vars = nil)
        Arel::Nodes::NamedFunction.new(
          "jsonb_path_exists",
          [value_field_jsonb, *[jsonpath, vars&.to_json].compact.map { Arel::Nodes.build_quoted(_1) }],
        )
      end

      def eq(target, value)
        if value.is_a?(TrueClass) || value.is_a?(FalseClass) || value.is_a?(NilClass)
          Arel::Nodes::InfixOperation.new("IS", target, Arel::Nodes.build_quoted(value))
        else
          target.eq(value)
        end
      end

      def not_eq(target, value)
        if value.is_a?(TrueClass) || value.is_a?(FalseClass) || value.is_a?(NilClass)
          Arel::Nodes::InfixOperation.new("IS NOT", target, Arel::Nodes.build_quoted(value))
        else
          # Comparison with NULL always returns NULL.
          # NOT NULL is always NULL as well.
          # We expect them not to be equal to any provided value except TRUE, FALSE and NULL.
          # So we should search for NULL values too.
          target.not_eq(value).or(target.eq(nil))
        end
      end

      def gt(target, value)
        target.gt(value)
      end

      def gteq(target, value)
        target.gteq(value)
      end

      def lt(target, value)
        target.lt(value)
      end

      def lteq(target, value)
        target.lteq(value)
      end

      def operator_not_found!(operator)
        raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{self.class.name}`"
      end
    end
  end
end
