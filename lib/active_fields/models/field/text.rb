# frozen_string_literal: true

module ActiveFields
  class Field
    class Text < ActiveFields::Field
      store_accessor :options, :min_length, :max_length

      # attribute :min_length, :integer
      # attribute :max_length, :integer

      validates :min_length, numericality: { greater_than_or_equal_to: 0 }
      validates :max_length, numericality: { greater_than_or_equal_to: ->(r) { r.min_length || 0 } }, allow_nil: true

      %i[min_length max_length].each do |column|
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
