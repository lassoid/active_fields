# frozen_string_literal: true

require_relative "application_record"

class Comment < ApplicationRecord
  belongs_to :post
end
