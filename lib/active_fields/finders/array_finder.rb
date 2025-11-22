# frozen_string_literal: true

module ActiveFields
  module Finders
    class ArrayFinder < BaseFinder
      private

      # This method defines a JSONPath query for searching within a `jsonb` field.
      # It must be implemented in a subclass and include a `$value` parameter,
      # which will be replaced with the provided value during search operations.
      # Refer to descendant implementations for examples.
      # For more details, see the PostgreSQL documentation: https://www.postgresql.org/docs/current/functions-json.html
      def jsonpath(operator) = raise NotImplementedError

      # Arel query node that searches for records where any element matches the JSONPath
      def value_match_any(operator, value)
        jsonb_path_exists(
          value_field_jsonb,
          jsonpath(operator),
          { value: value },
        )
      end

      # Arel query node that searches for records where all elements match the JSONPath
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

      # Arel query node that searches for records where the array size is equal to the provided value
      def value_size_eq(value)
        value = cast_int(value)
        jsonb_array_length(value_field_jsonb).eq(value)
      end

      # Arel query node that searches for records where the array size is not equal to the provided value
      def value_size_not_eq(value)
        value = cast_int(value)
        jsonb_array_length(value_field_jsonb).not_eq(value)
      end

      # Arel query node that searches for records where the array size is greater than the provided value
      def value_size_gt(value)
        value = cast_int(value)
        jsonb_array_length(value_field_jsonb).gt(value)
      end

      # Arel query node that searches for records where the array size is greater than or equal to the provided value
      def value_size_gteq(value)
        value = cast_int(value)
        jsonb_array_length(value_field_jsonb).gteq(value)
      end

      # Arel query node that searches for records where the array size is less than the provided value
      def value_size_lt(value)
        value = cast_int(value)
        jsonb_array_length(value_field_jsonb).lt(value)
      end

      # Arel query node that searches for records where the array size is less than or equal to the provided value
      def value_size_lteq(value)
        value = cast_int(value)
        jsonb_array_length(value_field_jsonb).lteq(value)
      end

      # Casts given value to integer, useful for querying by array size
      def cast_int(value)
        Casters::IntegerCaster.new.deserialize(value)
      end

      # Arel node for `active_fields.value_meta->const`
      def value_field_jsonb
        Arel::Nodes::InfixOperation.new(
          "->",
          Arel::Table.new(cte_name)[:value_meta],
          Arel::Nodes.build_quoted("const"),
        )
      end

      # Arel node for `jsonb_path_exists` PostgreSQL function
      def jsonb_path_exists(target, jsonpath, vars = nil)
        Arel::Nodes::NamedFunction.new(
          "jsonb_path_exists",
          [
            target,
            *[jsonpath, vars&.to_json].compact.map { |element| Arel::Nodes.build_quoted(element) },
          ],
        )
      end

      # Arel node for `jsonb_path_query_array` PostgreSQL function
      def jsonb_path_query_array(target, jsonpath, vars = nil)
        Arel::Nodes::NamedFunction.new(
          "jsonb_path_query_array",
          [
            target,
            *[jsonpath, vars&.to_json].compact.map { |element| Arel::Nodes.build_quoted(element) },
          ],
        )
      end

      # Arel node for `jsonb_array_length` PostgreSQL function
      def jsonb_array_length(target)
        Arel::Nodes::NamedFunction.new("jsonb_array_length", [target])
      end
    end
  end
end
