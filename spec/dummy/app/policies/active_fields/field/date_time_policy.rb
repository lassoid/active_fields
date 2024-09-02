# frozen_string_literal: true

module ActiveFields
  module Field
    class DateTimePolicy < ApplicationPolicy
      def permitted_attributes_for_create
        %i[customizable_type name required min max precision default_value]
      end

      def permitted_attributes_for_update
        %i[name default_value]
      end
    end
  end
end
