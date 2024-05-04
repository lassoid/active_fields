# frozen_string_literal: true

require_relative "../field"

module ActiveFields
  class Field
    class Boolean < ActiveFields::Field
      store_accessor :options, :required, :nullable

      # attribute :required, :boolean, default: false
      # attribute :nullable, :boolean, default: false

      validates :required, exclusion: [nil]
      validates :nullable, exclusion: [nil]

      %i[required nullable].each do |column|
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

      private

      def set_defaults
        self.required ||= false
        self.nullable ||= false
      end
    end
  end
end
