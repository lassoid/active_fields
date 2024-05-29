# frozen_string_literal: true

# If the value class is set to default, we disallow loading the custom class.
# This is an inversion of the same conditional statement from ActiveFields::Field::Base
unless ActiveFields.config.field_base_class_changed?
  raise NameError,
    "Use '#{ActiveFields.config.field_base_class}' instead of 'CustomField'"
end

class CustomField < ApplicationRecord
  self.table_name = "active_fields"

  include ActiveFields::FieldConcern
end
