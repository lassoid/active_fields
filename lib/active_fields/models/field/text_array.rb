# frozen_string_literal: true

require_relative "../field"

module ActiveFields
  class Field
    class TextArray < ActiveFields::Field
      store_accessor :options, :min_size, :max_size, :min_length, :max_length

      # attribute :min_size, :integer
      # attribute :max_size, :integer
      # attribute :min_length, :integer
      # attribute :max_length, :integer

      validates :min_size, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true
      validates :max_size, comparison: { greater_than_or_equal_to: ->(r) { r.min_size || 0 } }, allow_nil: true
      validates :min_length, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true
      validates :max_length, comparison: { greater_than_or_equal_to: ->(r) { r.min_length || 0 } }, allow_nil: true

      %i[min_size max_size min_length max_length].each do |column|
        define_method(column) do
          ActiveFields::Casters::IntegerCaster.new.deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(ActiveFields::Casters::IntegerCaster.new.serialize(other))
        end
      end

      private

      def set_defaults; end
    end
  end
end
