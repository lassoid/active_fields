# frozen_string_literal: true

# If the value class is set to default, we disallow loading the custom class.
# This is an inversion of the same conditional statement from ActiveFields::Value
if ActiveFields.config.value_class_changed?
  class CustomValue < ApplicationRecord
    self.table_name = "active_fields_values"

    include ActiveFields::ValueConcern
  end
else
  class CustomValue; end
end
