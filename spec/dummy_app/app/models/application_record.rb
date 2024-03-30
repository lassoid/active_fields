# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include ActiveFields::Concern

  self.abstract_class = true
end
