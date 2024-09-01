# frozen_string_literal: true

class IpField < ActiveFields.config.field_base_class
  acts_as_active_field(
    validator: {
      class_name: "IpValidator",
      options: -> { { required: required? } },
    },
    caster: {
      class_name: "IpCaster",
    },
  )

  store_accessor :options, :required

  validates :required, exclusion: [nil]

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

  private

  def set_defaults
    self.required ||= false
  end
end
