# frozen_string_literal: true

# If the field base class has been changed, we should disallow loading this model.
# So we are raising a NameError exception, as if there is no such class at all.
if ActiveFields.config.field_base_class_changed?
  raise NameError,
    "Use '#{ActiveFields.config.field_base_class}' instead of '#{ActiveFields::Config::DEFAULT_FIELD_BASE_CLASS}'"
end

module ActiveFields
  module Field
    class Base < ApplicationRecord
      self.table_name = "active_fields"

      include FieldConcern
    end
  end
end
