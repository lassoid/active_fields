# frozen_string_literal: true

require_relative "application_record"

class Comment < ApplicationRecord
  has_active_fields

  belongs_to :post
end
