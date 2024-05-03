# frozen_string_literal: true

FactoryBot.define do
  factory :active_field_value, class: "ActiveFields::Value" do
    # We can't manually create a custom_field record,
    # because a record with the same active_field and customizable
    # is automatically created by customizable or active_field callbacks.
    # So, to get a new custom_field persisted record,
    # we should create customizable and active_field records
    # and than fetch custom_field record associated with them.
    skip_create

    customizable { association %i[post comment].sample }
  end

  factory :text_active_field_value, parent: :active_field_value, class: "ActiveFields::Value" do
    active_field factory: %i[text_active_field]
    sequence(:value) { |n| "Value #{n}" }
  end

  factory :text_array_active_field_value, parent: :active_field_value, class: "ActiveFields::Value" do
    active_field factory: %i[text_array_active_field]
    sequence(:value) { |n| ["Value #{n}", "Second value #{n}"] }
  end

  factory :enum_active_field_value, parent: :active_field_value, class: "ActiveFields::Value" do
    active_field factory: %i[enum_active_field]
    sequence(:value) { |n| "Value #{n}" }
  end

  factory :enum_array_active_field_value, parent: :active_field_value, class: "ActiveFields::Value" do
    active_field factory: %i[enum_array_active_field]
    sequence(:value) { |n| ["Value #{n}", "Second value #{n}"] }
  end

  factory :integer_active_field_value, parent: :active_field_value, class: "ActiveFields::Value" do
    active_field factory: %i[integer_active_field]
    sequence(:value) { |n| n }
  end

  factory :integer_array_active_field_value, parent: :active_field_value, class: "ActiveFields::Value" do
    active_field factory: %i[integer_array_active_field]
    sequence(:value) { |n| [n, n + 1] }
  end

  factory :decimal_active_field_value, parent: :active_field_value, class: "ActiveFields::Value" do
    active_field factory: %i[decimal_active_field]
    sequence(:value, &:to_d)
  end

  factory :decimal_array_active_field_value, parent: :active_field_value, class: "ActiveFields::Value" do
    active_field factory: %i[decimal_array_active_field]
    sequence(:value) { |n| [n.to_d, (n + 1).to_d] }
  end

  factory :date_active_field_value, parent: :active_field_value, class: "ActiveFields::Value" do
    active_field factory: %i[date_active_field]
    sequence(:value) { |n| Date.today + n }
  end

  factory :date_array_active_field_value, parent: :active_field_value, class: "ActiveFields::Value" do
    active_field factory: %i[date_array_active_field]
    sequence(:value) { |n| [Date.today + n, Date.tomorrow + n] }
  end

  factory :boolean_active_field_value, parent: :active_field_value, class: "ActiveFields::Value" do
    active_field factory: %i[boolean_active_field]
    sequence(:value, &:even?)
  end
end
