# frozen_string_literal: true

class Post < ApplicationRecord
  has_active_fields types: %i[boolean date_array decimal ip ip_array]

  belongs_to :author, optional: true, inverse_of: :posts
end
