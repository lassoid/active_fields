# frozen_string_literal: true

FactoryBot.define do
  factory :active_value, class: "ActiveFields::Value" do
    # We can't manually create an active_value record,
    # because a record with the same active_field and customizable
    # is automatically created by customizable or active_field callbacks.
    # So, to get a new active_value persisted record,
    # we should create customizable and active_field records
    # and than fetch active_value record associated with them.
    skip_create

    active_field { association TestMethods.random_active_field_factory }
    customizable { active_field&.customizable_type&.constantize&.new || [Author, Post].sample.new }
    value { TestMethods.active_value_for(active_field) if active_field }
  end
end
