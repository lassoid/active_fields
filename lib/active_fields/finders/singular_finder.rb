# frozen_string_literal: true

module ActiveFields
  module Finders
    class SingularFinder < BaseFinder
      private

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
    end
  end
end
