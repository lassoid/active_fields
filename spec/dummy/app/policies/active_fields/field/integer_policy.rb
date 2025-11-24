# frozen_string_literal: true

module ActiveFields
  module Field
    class IntegerPolicy < ApplicationPolicy
      def permitted_attributes_for_create
        %i[customizable_type name scope required min max default_value]
      end

      def permitted_attributes_for_update
        %i[name default_value]
      end
    end
  end
end
