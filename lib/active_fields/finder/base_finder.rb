# frozen_string_literal: true

module ActiveFields
  module Finders
    class BaseFinder
      class << self
        def call(scope:, operator:, value:)
          raise NotImplementedError
        end

        private

        def value_field
          Arel::Nodes::InfixOperation.new(
            "->>",
            ActiveFields.config.value_class.arel_table[:value_meta],
            Arel::Nodes.build_quoted("const"),
          )
        end

        def casted_value_field(to)
          Arel::Nodes::NamedFunction.new("CAST", [value_field.as(to)])
        end

        def is_operation(target, value)
          Arel::Nodes::InfixOperation.new("IS", target, Arel::Nodes.build_quoted(value))
        end

        def is_not_operation(target, value)
          Arel::Nodes::InfixOperation.new("IS NOT", target, Arel::Nodes.build_quoted(value))
        end
      end
    end
  end
end
