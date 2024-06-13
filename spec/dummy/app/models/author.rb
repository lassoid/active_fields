# frozen_string_literal: true

class Author < ApplicationRecord
  has_active_fields

  belongs_to :group, optional: true, inverse_of: :authors
  has_many :posts, inverse_of: :author
end
