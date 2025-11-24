# frozen_string_literal: true

module ActiveFields
  module Field
    class EnumPolicy < ApplicationPolicy
      def permitted_attributes_for_create
        [
          :customizable_type,
          :name,
          :scope,
          :required,
          :default_value,
          allowed_values: [],
        ]
      end

      def permitted_attributes_for_update
        %i[name default_value]
      end
    end
  end
end
