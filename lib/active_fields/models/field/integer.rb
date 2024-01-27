# frozen_string_literal: true

module ActiveFields
  class Field
    class Integer < ActiveFields::Field
      store_accessor :options, :required, :min, :max

      # attribute :required, :boolean, default: false
      # attribute :min, :integer
      # attribute :max, :integer

      validates :required, exclusion: [nil]
      validates :max, numericality: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min

      %i[required].each do |column|
        define_method(column) do
          ActiveModel::Type::Boolean.new.cast(super)
        end

        define_method("#{column}?") do
          ActiveModel::Type::Boolean.new.cast(super)
        end

        define_method("#{column}=") do |other|
          super(ActiveModel::Type::Boolean.new.cast(other))
        end
      end

      %i[min max].each do |column|
        define_method(column) do
          ActiveModel::Type::Integer.new.cast(super)
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
