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

      def cte_name = "active_values_for_field"

      def active_values_cte
        ActiveFields.config.value_class.with(cte_name => active_field.active_values).from(cte_name)
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

      def is(target, value)
        Arel::Nodes::InfixOperation.new("IS", target, Arel::Nodes.build_quoted(value))
      end

      # rubocop:disable Naming/PredicateName
      def is_not(target, value)
        Arel::Nodes::InfixOperation.new("IS NOT", target, Arel::Nodes.build_quoted(value))
      end
      # rubocop:enable Naming/PredicateName

      def value_jsonb_path_exists(jsonpath, vars = nil)
        Arel::Nodes::NamedFunction.new(
          "jsonb_path_exists",
          [value_field_jsonb, *[jsonpath, vars&.to_json].compact.map { Arel::Nodes.build_quoted(_1) }],
        )
      end

      def operator_not_found!(operator)
        raise ArgumentError, "invalid search operator `#{operator.inspect}` for `#{self.class.name}`"
      end
    end
  end
end
