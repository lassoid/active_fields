# frozen_string_literal: true

module ActiveFields
  module Field
    class EnumArray < ActiveFields.config.field_base_class
      include FieldArrayConcern

      store_accessor :options, :allowed_values

      validate :validate_allowed_values

      %i[allowed_values].each do |column|
        define_method(column) do
          Casters::TextArrayCaster.new(nil).deserialize(super())
        end

        define_method(:"#{column}=") do |other|
          super(Casters::TextArrayCaster.new(nil).serialize(other))
        end
      end

      private

      def validate_allowed_values
        if allowed_values.nil?
          errors.add(:allowed_values, :blank)
        elsif allowed_values.is_a?(Array)
          if allowed_values.empty?
            errors.add(:allowed_values, :blank)
          elsif allowed_values.any? { !_1.is_a?(String) }
            errors.add(:allowed_values, :invalid)
          end
        else
          errors.add(:allowed_values, :invalid)
        end
      end

      def set_defaults
        self.allowed_values ||= []
      end
    end
  end
end
