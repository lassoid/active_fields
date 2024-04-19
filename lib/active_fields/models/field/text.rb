# frozen_string_literal: true

require_relative "../field"

module ActiveFields
  class Field
    class Text < ActiveFields::Field
      store_accessor :options, :required, :min_length, :max_length

      # attribute :required, :boolean, default: false
      # attribute :min_length, :integer
      # attribute :max_length, :integer

      validates :required, exclusion: [nil]
      validates :min_length, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
      validates :max_length, numericality: { greater_than_or_equal_to: ->(r) { r.min_length || 0 } }, allow_nil: true

      %i[required].each do |column|
        define_method(column) do
          ActiveModel::Type::Boolean.new.cast(super())
        end

        define_method("#{column}?") do
          !!public_send(column)
        end

        define_method("#{column}=") do |other|
          super(ActiveModel::Type::Boolean.new.cast(other))
        end
      end

      %i[min_length max_length].each do |column|
        define_method(column) do
          ActiveModel::Type::Integer.new.cast(super())
        end

        define_method("#{column}=") do |other|
          super(ActiveModel::Type::Integer.new.cast(other))
        end
      end

      private

      def set_defaults
        self.required ||= false
      end
    end
  end
end
