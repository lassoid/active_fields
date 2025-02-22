# frozen_string_literal: true

# If the field base class is set to default, we disallow loading the custom model class.
# This is an inversion of the same conditional statement from ActiveFields::Field::Base
if ActiveFields.config.field_base_class_changed?
  class CustomField < ApplicationRecord
    self.table_name = "active_fields"

    include ActiveFields::FieldConcern
  end
else
  class CustomField; end
end
