# frozen_string_literal: true

# If the value class has been changed, we should disallow loading this model.
# So we are raising a NameError exception, as if there is no such class at all.
if ActiveFields.config.value_class_changed?
  raise NameError,
    "Use '#{ActiveFields.config.value_class}' instead of '#{ActiveFields::Config::DEFAULT_VALUE_CLASS}'"
end

module ActiveFields
  class Value < ApplicationRecord
    self.table_name = "active_fields_values"

    include ValueConcern
  end
end
