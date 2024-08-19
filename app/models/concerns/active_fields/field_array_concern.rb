# frozen_string_literal: true

module ActiveFields
  # Mix-in that adds array functionality to the active fields model
  module FieldArrayConcern
    extend ActiveSupport::Concern

    included do
      store_accessor :options, :min_size, :max_size

      validates :min_size, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true
      validates :max_size, comparison: { greater_than_or_equal_to: ->(r) { r.min_size || 0 } }, allow_nil: true

      %i[min_size max_size].each do |column|
        define_method(column) do
          Casters::IntegerCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::IntegerCaster.new(nil).serialize(other))
        end
      end
    end

    def array? = true
  end
end
