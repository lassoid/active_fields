# frozen_string_literal: true

module ActiveFields
  module Finders
    class TextFinder < SingularFinder
      def search(operator:, value:)
        case operator.to_s
        when *OPS[:eq]
          scope.where(eq(casted_value_field("text"), cast(value)))
        when *OPS[:not_eq]
          scope.where(not_eq(casted_value_field("text"), cast(value)))

        when *OPS[:start_with]
          scope.where(like(casted_value_field("text"), "#{escape_pattern(cast(value))}%"))
        when *OPS[:end_with]
          scope.where(like(casted_value_field("text"), "%#{escape_pattern(cast(value))}"))
        when *OPS[:contain]
          scope.where(like(casted_value_field("text"), "%#{escape_pattern(cast(value))}%"))
        when *OPS[:not_start_with]
          scope.where(not_like(casted_value_field("text"), "#{escape_pattern(cast(value))}%"))
        when *OPS[:not_end_with]
          scope.where(not_like(casted_value_field("text"), "%#{escape_pattern(cast(value))}"))
        when *OPS[:not_contain]
          scope.where(not_like(casted_value_field("text"), "%#{escape_pattern(cast(value))}%"))

        when *OPS[:istart_with]
          scope.where(ilike(casted_value_field("text"), "#{escape_pattern(cast(value))}%"))
        when *OPS[:iend_with]
          scope.where(ilike(casted_value_field("text"), "%#{escape_pattern(cast(value))}"))
        when *OPS[:icontain]
          scope.where(ilike(casted_value_field("text"), "%#{escape_pattern(cast(value))}%"))
        when *OPS[:not_istart_with]
          scope.where(not_ilike(casted_value_field("text"), "#{escape_pattern(cast(value))}%"))
        when *OPS[:not_iend_with]
          scope.where(not_ilike(casted_value_field("text"), "%#{escape_pattern(cast(value))}"))
        when *OPS[:not_icontain]
          scope.where(not_ilike(casted_value_field("text"), "%#{escape_pattern(cast(value))}%"))
        else
          operator_not_found!(operator)
        end
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
