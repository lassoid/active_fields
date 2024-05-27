# frozen_string_literal: true

class Author < ApplicationRecord
  # TODO: add specs with configured fields
  has_active_fields

  has_many :posts, inverse_of: :author
end
