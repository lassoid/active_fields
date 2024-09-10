# frozen_string_literal: true

p "Loaded ActiveFields::Value"
module ActiveFields
  # If value base class has been changed, we should prevent this model from being loaded.
  # Since we cannot remove it entirely, we will not add any functionality to it.
  if ActiveFields.config.value_class_changed?
    class Value; end
  else
    class Value < ApplicationRecord
      self.table_name = "active_fields_values"

      include ValueConcern
    end
  end
end
