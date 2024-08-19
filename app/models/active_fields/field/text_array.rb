# frozen_string_literal: true

module ActiveFields
  module Field
    class TextArray < ActiveFields.config.field_base_class
      include FieldArrayConcern

      store_accessor :options, :min_length, :max_length

      validates :min_length, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true
      validates :max_length, comparison: { greater_than_or_equal_to: ->(r) { r.min_length || 0 } }, allow_nil: true

      %i[min_length max_length].each do |column|
        define_method(column) do
          Casters::IntegerCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::IntegerCaster.new(nil).serialize(other))
        end
      end

      private

      def set_defaults; end
    end
  end
end
