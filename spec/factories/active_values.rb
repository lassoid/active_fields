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

    active_field do
      association %i[
        boolean_active_field
        date_active_field
        date_array_active_field
        decimal_active_field
        decimal_array_active_field
        enum_active_field
        enum_array_active_field
        integer_active_field
        integer_array_active_field
        text_active_field
        text_array_active_field
      ].sample
    end
    customizable { active_field&.customizable_type&.constantize&.new || [Post, Comment].sample.new }
    value { active_field&.default_value }
  end
end
