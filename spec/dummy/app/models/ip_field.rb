# frozen_string_literal: true

class IpField < ActiveFields.config.field_base_class
  store_accessor :options, :required

  validates :required, exclusion: [nil]

  %i[required].each do |column|
    define_method(column) do
      ActiveFields::Casters::BooleanCaster.new(nil).deserialize(super())
    end

    define_method(:"#{column}?") do
      !!public_send(column)
    end

    define_method(:"#{column}=") do |other|
      super(ActiveFields::Casters::BooleanCaster.new(nil).serialize(other))
    end
  end

  def value_validator_class
    IpValidator
  end

  def value_caster_class
    IpCaster
  end

  private

  def set_defaults
    self.required ||= false
  end
end
