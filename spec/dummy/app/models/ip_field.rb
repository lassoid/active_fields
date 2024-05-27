# frozen_string_literal: true

class IpField < ActiveFields.config.field_model
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
