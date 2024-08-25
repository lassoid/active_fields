# frozen_string_literal: true

FactoryBot.define do
  factory = ActiveFields.config.value_class_changed? ? :custom_value : :active_value
  class_name = ActiveFields.config.value_class_name

  factory factory, class: class_name do
    active_field { association TestMethods.random_active_field_factory }
    customizable { active_field&.customizable_type&.constantize&.new || TestMethods.dummy_models.sample.new }
    value { TestMethods.active_value_for(active_field) if active_field }
  end
end
