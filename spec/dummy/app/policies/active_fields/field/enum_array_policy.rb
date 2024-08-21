# frozen_string_literal: true

module ActiveFields
  module Field
    class EnumArrayPolicy < ApplicationPolicy
      def permitted_attributes_for_create
        [
          :customizable_type,
          :name,
          :min_size,
          :max_size,
          allowed_values: [],
          default_value: [],
        ]
      end

      def permitted_attributes_for_update
        %i[name]
      end
    end
  end
end
