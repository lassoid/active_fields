# frozen_string_literal: true

module ActiveFields
  module Field
    class DateArray < ActiveFields.config.field_base_class
      include FieldArrayConcern

      store_accessor :options, :min, :max

      validates :max, comparison: { greater_than_or_equal_to: :min }, allow_nil: true, if: :min

      %i[min max].each do |column|
        define_method(column) do
          Casters::DateCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::DateCaster.new(nil).serialize(other))
        end
      end

      private

      def set_defaults; end
    end
  end
end
