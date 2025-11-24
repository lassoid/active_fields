# frozen_string_literal: true

class User < ApplicationRecord
  has_active_fields scope_method: :tenant_id
end
