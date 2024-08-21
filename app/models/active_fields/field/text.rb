# frozen_string_literal: true

module ActiveFields
  module Field
    class Text < ActiveFields.config.field_base_class
      store_accessor :options, :required, :min_length, :max_length

      validates :required, exclusion: [nil]
      validates :min_length, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true
      validates :max_length, comparison: { greater_than_or_equal_to: ->(r) { r.min_length || 0 } }, allow_nil: true

      %i[required].each do |column|
        define_method(column) do
          Casters::BooleanCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}?") do
          !!public_send(column)
        end

        define_method(:"#{column}=") do |other|
          super(Casters::BooleanCaster.new(nil).serialize(other))
        end
      end

      %i[min_length max_length].each do |column|
        define_method(column) do
          Casters::IntegerCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::IntegerCaster.new(nil).serialize(other))
        end
      end

      private

      def set_defaults
        self.required ||= false
      end
    end
  end
end
