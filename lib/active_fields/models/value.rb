# frozen_string_literal: true

# == Schema Information
#
# Table name: active_fields_values
#
#  id                :bigint           not null, primary key
#  customizable_type :string           not null
#  value             :jsonb
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  customizable_id   :bigint           not null
#  active_field_id   :bigint           not null
#
# Indexes
#
#  index_active_fields_values_on_customizable_and_field  (customizable_type,customizable_id,active_field_id) UNIQUE
#  index_active_fields_values_on_active_field_id                (active_field_id)
#
# Foreign Keys
#
#  active_fields_values_active_field_id_fk  (active_field_id => active_fields.id)
#
module ActiveFields
  class Value < ::ActiveRecord::Base
    self.table_name = "active_fields_values"

    include ActiveFields::ValueConcern
  end
end
