# frozen_string_literal: true

require_relative "application_record"

class Post < ApplicationRecord
  has_active_fields

  belongs_to :author, optional: true, inverse_of: :posts
end
