# frozen_string_literal: true

module ActiveFields
  module Finders
    class TextFinder < SingularFinder
      operation :eq, operators: OPS[:eq] do |value|
        scope.where(eq(casted_value_field("text"), cast(value)))
      end
      operation :not_eq, operators: OPS[:not_eq] do |value|
        scope.where(not_eq(casted_value_field("text"), cast(value)))
      end
      operation :start_with, operators: OPS[:start_with] do |value|
        scope.where(like(casted_value_field("text"), "#{escape_pattern(cast(value))}%"))
      end
      operation :end_with, operators: OPS[:end_with] do |value|
        scope.where(like(casted_value_field("text"), "%#{escape_pattern(cast(value))}"))
      end
      operation :contain, operators: OPS[:contain] do |value|
        scope.where(like(casted_value_field("text"), "%#{escape_pattern(cast(value))}%"))
      end
      operation :not_start_with, operators: OPS[:not_start_with] do |value|
        scope.where(not_like(casted_value_field("text"), "#{escape_pattern(cast(value))}%"))
      end
      operation :not_end_with, operators: OPS[:not_end_with] do |value|
        scope.where(not_like(casted_value_field("text"), "%#{escape_pattern(cast(value))}"))
      end
      operation :not_contain, operators: OPS[:not_contain] do |value|
        scope.where(not_like(casted_value_field("text"), "%#{escape_pattern(cast(value))}%"))
      end
      operation :istart_with, operators: OPS[:istart_with] do |value|
        scope.where(ilike(casted_value_field("text"), "#{escape_pattern(cast(value))}%"))
      end
      operation :iend_with, operators: OPS[:iend_with] do |value|
        scope.where(ilike(casted_value_field("text"), "%#{escape_pattern(cast(value))}"))
      end
      operation :icontain, operators: OPS[:icontain] do |value|
        scope.where(ilike(casted_value_field("text"), "%#{escape_pattern(cast(value))}%"))
      end
      operation :not_istart_with, operators: OPS[:not_istart_with] do |value|
        scope.where(not_ilike(casted_value_field("text"), "#{escape_pattern(cast(value))}%"))
      end
      operation :not_iend_with, operators: OPS[:not_iend_with] do |value|
        scope.where(not_ilike(casted_value_field("text"), "%#{escape_pattern(cast(value))}"))
      end
      operation :not_icontain, operators: OPS[:not_icontain] do |value|
        scope.where(not_ilike(casted_value_field("text"), "%#{escape_pattern(cast(value))}%"))
      end

      private

      def cast(value)
        Casters::TextCaster.new.deserialize(value)
      end

      def like(target, value)
        target.matches(value, nil, true)
      end

      def ilike(target, value)
        target.matches(value, nil, false)
      end

      def not_like(target, value)
        # We expect NULLs to never match the pattern
        target.does_not_match(value, nil, true).or(target.eq(nil))
      end

      def not_ilike(target, value)
        # We expect NULLs to never match the pattern
        target.does_not_match(value, nil, false).or(target.eq(nil))
      end

      # Escape special chars (\, %, _) in LIKE/ILIKE pattern
      def escape_pattern(value)
        return unless value.is_a?(String)

        value.gsub("\\", "\\\\\\").gsub("%", "\\%").gsub("_", "\\_")
      end
    end
  end
end
