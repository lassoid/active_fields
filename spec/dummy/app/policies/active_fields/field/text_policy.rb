# frozen_string_literal: true

module ActiveFields
  module Field
    class TextPolicy < ApplicationPolicy
      def permitted_attributes_for_create
        %i[customizable_type name min_length max_length default_value]
      end

      def permitted_attributes_for_update
        %i[name]
      end
    end
  end
end
