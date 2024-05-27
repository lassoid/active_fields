# frozen_string_literal: true

module ActiveFields
  class Field < ApplicationRecord
    self.table_name = "active_fields"

    include FieldConcern
  end
end
