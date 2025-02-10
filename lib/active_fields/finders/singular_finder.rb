# frozen_string_literal: true

module ActiveFields
  module Finders
    class SingularFinder < BaseFinder
      private

      # Arel node for `active_fields.value_meta->>const`
      def value_field_text
        Arel::Nodes::InfixOperation.new(
          "->>",
          Arel::Table.new(cte_name)[:value_meta],
          Arel::Nodes.build_quoted("const"),
        )
      end

      # Arel node with stored value casted to provided type
      # E.g. `CAST active_fields.value_meta->>const AS bigint`
      def casted_value_field(to)
        Arel::Nodes::NamedFunction.new("CAST", [value_field_text.as(to)])
      end

      # Equal operation, that respects boolean and NULL values
      def eq(target, value)
        if value.is_a?(TrueClass) || value.is_a?(FalseClass) || value.is_a?(NilClass)
          Arel::Nodes::InfixOperation.new("IS", target, Arel::Nodes.build_quoted(value))
        else
          target.eq(value)
        end
      end

      # Not equal operation, that respects boolean and NULL values
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

      # Greater than operation
      def gt(target, value)
        target.gt(value)
      end

      # Greater than or equal to operation
      def gteq(target, value)
        target.gteq(value)
      end

      # Less than operation
      def lt(target, value)
        target.lt(value)
      end

      # Less than or equal to operation
      def lteq(target, value)
        target.lteq(value)
      end
    end
  end
end
