# frozen_string_literal: true

module ActiveFields
  module Field
    class Boolean < ActiveFields.config.field_base_class
      store_accessor :options, :required, :nullable

      # attribute :required, :boolean, default: false
      # attribute :nullable, :boolean, default: false

      validates :required, exclusion: [nil]
      validates :nullable, exclusion: [nil]

      %i[required nullable].each do |column|
        define_method(column) do
          Casters::BooleanCaster.new.deserialize(super())
        end

        define_method(:"#{column}?") do
          !!public_send(column)
        end

        define_method(:"#{column}=") do |other|
          super(Casters::BooleanCaster.new.serialize(other))
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
