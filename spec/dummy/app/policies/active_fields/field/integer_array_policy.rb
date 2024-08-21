# frozen_string_literal: true

module ActiveFields
  module Field
    class IntegerArrayPolicy < ApplicationPolicy
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
        %i[name]
      end
    end
  end
end
