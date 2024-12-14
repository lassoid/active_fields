# frozen_string_literal: true

module ActiveFields
  module Finders
    class ArrayFinder < BaseFinder
      private

      def value_field_jsonb
        Arel::Nodes::InfixOperation.new(
          "->",
          Arel::Table.new(cte_name)[:value_meta],
          Arel::Nodes.build_quoted("const"),
        )
      end

      def jsonb_path_exists(target, jsonpath, vars = nil)
        Arel::Nodes::NamedFunction.new(
          "jsonb_path_exists",
          [target, *[jsonpath, vars&.to_json].compact.map { Arel::Nodes.build_quoted(_1) }],
        )
      end

      def jsonb_path_query_array(target, jsonpath, vars = nil)
        Arel::Nodes::NamedFunction.new(
          "jsonb_path_query_array",
          [target, *[jsonpath, vars&.to_json].compact.map { Arel::Nodes.build_quoted(_1) }],
        )
      end

      def jsonb_array_length(target)
        Arel::Nodes::NamedFunction.new("jsonb_array_length", [target])
      end

      def value_match_any(operator, value)
        jsonb_path_exists(
          value_field_jsonb,
          jsonpath(operator),
          { value: value },
        )
      end

      def value_match_all(operator, value)
        jsonb_array_length(value_field_jsonb).gt(0)
          .and(
            jsonb_array_length(value_field_jsonb).eq(
              jsonb_array_length(
                jsonb_path_query_array(
                  value_field_jsonb,
                  jsonpath(operator),
                  { value: value },
                ),
              ),
            ),
          )
      end

      def value_size_eq(value)
        jsonb_array_length(value_field_jsonb).eq(value)
      end

      def value_size_not_eq(value)
        jsonb_array_length(value_field_jsonb).not_eq(value)
      end

      def value_size_gt(value)
        jsonb_array_length(value_field_jsonb).gt(value)
      end

      def value_size_gteq(value)
        jsonb_array_length(value_field_jsonb).gteq(value)
      end

      def value_size_lt(value)
        jsonb_array_length(value_field_jsonb).lt(value)
      end

      def value_size_lteq(value)
        jsonb_array_length(value_field_jsonb).lteq(value)
      end

      def cast_int(value)
        Casters::IntegerCaster.new.deserialize(value)
      end
    end
  end
end
