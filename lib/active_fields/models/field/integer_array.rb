# frozen_string_literal: true

module ActiveFields
  class Field
    class IntegerArray < ActiveFields::Field
      store_accessor :options, :min, :max, :min_size, :max_size

      # attribute :min, :integer
      # attribute :max, :integer
      # attribute :min_size, :integer
      # attribute :max_size, :integer

      validates :max, numericality: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min
      validates :min_size, numericality: { greater_than_or_equal_to: 0 }
      validates :max_size, numericality: { greater_than_or_equal_to: ->(r) { r.min_size || 0 } }, allow_nil: true

      %i[min max min_size max_size].each do |column|
        define_method(column) do
          ActiveModel::Type::Integer.new.cast(super)
        end

        define_method("#{column}=") do |other|
          super(ActiveModel::Type::Integer.new.cast(other))
        end
      end

      private

      def set_defaults; end
    end
  end
end
