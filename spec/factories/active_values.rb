# frozen_string_literal: true

FactoryBot.define do
  factory = ActiveFields.config.value_class_changed? ? :custom_value : :active_value
  class_name = ActiveFields.config.value_class

  # We can't manually create an active_value record,
  # because a record with the same active_field and customizable
  # is automatically created by customizable or active_field callbacks.
  # So, to get a new active_value persisted record,
  # we should create customizable and active_field records
  # and than fetch active_value record associated with them.
  factory factory, class: class_name do
    skip_create

    active_field { association TestMethods.random_active_field_factory }
    customizable { active_field&.customizable_type&.constantize&.new || TestMethods.dummy_models.sample.new }
    value { TestMethods.active_value_for(active_field) if active_field }
  end
end
