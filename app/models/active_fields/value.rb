# frozen_string_literal: true

module ActiveFields
  class Value < ApplicationRecord
    self.table_name = "active_fields_values"

    include ValueConcern
  end
end
