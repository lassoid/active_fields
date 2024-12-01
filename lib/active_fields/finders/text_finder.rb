# frozen_string_literal: true

module ActiveFields
  module Finders
    class TextFinder < BaseFinder
      def search(operator:, value:)
        value = Casters::TextCaster.new.deserialize(value)

        case operator.to_s
        when "=", "eq"
          active_values_cte.where(eq(casted_value_field("text"), value))
        when "!=", "not_eq"
          active_values_cte.where(not_eq(casted_value_field("text"), value))

        when "^", "start_with"
          active_values_cte.where(like(casted_value_field("text"), "#{escape_pattern(value)}%"))
        when "$", "end_with"
          active_values_cte.where(like(casted_value_field("text"), "%#{escape_pattern(value)}"))
        when "~", "contain"
          active_values_cte.where(like(casted_value_field("text"), "%#{escape_pattern(value)}%"))
        when "!^", "not_start_with"
          active_values_cte.where(not_like(casted_value_field("text"), "#{escape_pattern(value)}%"))
        when "!$", "not_end_with"
          active_values_cte.where(not_like(casted_value_field("text"), "%#{escape_pattern(value)}"))
        when "!~", "not_contain"
          active_values_cte.where(not_like(casted_value_field("text"), "%#{escape_pattern(value)}%"))

        when "^*", "istart_with"
          active_values_cte.where(ilike(casted_value_field("text"), "#{escape_pattern(value)}%"))
        when "$*", "iend_with"
          active_values_cte.where(ilike(casted_value_field("text"), "%#{escape_pattern(value)}"))
        when "~*", "icontain"
          active_values_cte.where(ilike(casted_value_field("text"), "%#{escape_pattern(value)}%"))
        when "!^*", "not_istart_with"
          active_values_cte.where(not_ilike(casted_value_field("text"), "#{escape_pattern(value)}%"))
        when "!$*", "not_iend_with"
          active_values_cte.where(not_ilike(casted_value_field("text"), "%#{escape_pattern(value)}"))
        when "!~*", "not_icontain"
          active_values_cte.where(not_ilike(casted_value_field("text"), "%#{escape_pattern(value)}%"))
        else
          operator_not_found!(operator)
        end
      end

      private

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

      def escape_pattern(value)
        return unless value.is_a?(String)

        value.gsub("\\", "\\\\\\").gsub("%", "\\%").gsub("_", "\\_")
      end
    end
  end
end
