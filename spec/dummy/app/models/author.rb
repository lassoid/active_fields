# frozen_string_literal: true

require_relative "application_record"

class Author < ApplicationRecord
  has_active_fields

  has_many :posts, inverse_of: :author
end
