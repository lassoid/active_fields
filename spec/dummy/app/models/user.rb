# frozen_string_literal: true

class User < ApplicationRecord
  has_active_fields scope_method: :tenant_id

  after_update :clear_unavailable_active_values, if: :saved_change_to_tenant_id?
end
