# frozen_string_literal: true

module ActiveFields
  module Field
    class EnumArrayPolicy < ApplicationPolicy
      def permitted_attributes_for_create
        [
          :customizable_type,
          :name,
          :scope,
          :min_size,
          :max_size,
          allowed_values: [],
          default_value: [],
        ]
      end

      def permitted_attributes_for_update
        [:name, default_value: []]
      end
    end
  end
end
