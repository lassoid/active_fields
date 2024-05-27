# frozen_string_literal: true

class Post < ApplicationRecord
  # TODO: add specs with configured fields
  has_active_fields

  belongs_to :author, optional: true, inverse_of: :posts
end
