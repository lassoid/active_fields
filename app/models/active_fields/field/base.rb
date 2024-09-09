# frozen_string_literal: true

module ActiveFields
  module Field
    p "Loaded ActiveFields::Field"
    # If the field base class has been changed, we should prevent this model from being loaded.
    # Since we cannot remove it entirely, we will not add any functionality to it.
    if ActiveFields.config.field_base_class_changed?
      class Base; end
    else
      class Base < ApplicationRecord
        self.table_name = "active_fields"

        include FieldConcern
      end
    end
  end
end
