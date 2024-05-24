# frozen_string_literal: true

module ActiveFields
  module Field
    class Text < ActiveFields.config.field_model
      store_accessor :options, :required, :min_length, :max_length

      # attribute :required, :boolean, default: false
      # attribute :min_length, :integer
      # attribute :max_length, :integer

      validates :required, exclusion: [nil]
      validates :min_length, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true
      validates :max_length, comparison: { greater_than_or_equal_to: ->(r) { r.min_length || 0 } }, allow_nil: true

      %i[required].each do |column|
        define_method(column) do
          ActiveFields::Casters::BooleanCaster.new.deserialize(super())
        end

        define_method(:"#{column}?") do
          !!public_send(column)
        end

        define_method(:"#{column}=") do |other|
          super(ActiveFields::Casters::BooleanCaster.new.serialize(other))
        end
      end

      %i[min_length max_length].each do |column|
        define_method(column) do
          ActiveFields::Casters::IntegerCaster.new.deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(ActiveFields::Casters::IntegerCaster.new.serialize(other))
        end
      end

      private

      def set_defaults
        self.required ||= false
      end
    end
  end
end
