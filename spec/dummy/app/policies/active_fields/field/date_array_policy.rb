# frozen_string_literal: true

module ActiveFields
  module Field
    class DateArrayPolicy < ApplicationPolicy
      def permitted_attributes_for_create
        [
          :customizable_type,
          :name,
          :min_size,
          :max_size,
          :min,
          :max,
          default_value: [],
        ]
      end

      def permitted_attributes_for_update
        [:name, default_value: []]
      end
    end
  end
end
