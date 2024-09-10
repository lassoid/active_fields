# frozen_string_literal: true

module ActiveFields
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
