# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :authors, inverse_of: :group
end
