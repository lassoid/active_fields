# frozen_string_literal: true

# == Schema Information
#
# Table name: active_fields
#
#  id                :bigint           not null, primary key
#  customizable_type :string           not null
#  default_value     :jsonb
#  name              :string           not null
#  options           :jsonb            default({}), not null
#  type              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_active_fields_on_customizable_type           (customizable_type)
#  index_active_fields_on_name_and_customizable_type  (name,customizable_type) UNIQUE
#
module ActiveFields
  module Field
    class Base < ::ActiveRecord::Base
      self.table_name = "active_fields"

      include ActiveFields::FieldConcern
    end
  end
end
