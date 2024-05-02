# frozen_string_literal: true

FactoryBot.define do
  # ActiveField::Field
  factory :active_field, class: "ActiveFields::Field" do
    sequence(:name) { |n| "field_#{n}" }

    customizable_type { ["Post", "Comment"].sample }
  end

  factory :text_active_field, parent: :active_field, class: "ActiveFields::Field::Text" do
    type { "ActiveFields::Field::Text" }
  end

  factory :text_array_active_field, parent: :active_field, class: "ActiveFields::Field::TextArray" do
    type { "ActiveFields::Field::TextArray" }
  end

  factory :enum_active_field, parent: :active_field, class: "ActiveFields::Field::Enum" do
    type { "ActiveFields::Field::Enum" }

    allowed_values { Array.new(5) { TestMethods.random_string(10) } }
    default_value do
      allowed = allowed_values.dup
      allowed << nil unless required

      allowed.sample
    end
  end

  factory :enum_array_active_field, parent: :active_field, class: "ActiveFields::Field::EnumArray" do
    type { "ActiveFields::Field::EnumArray" }

    allowed_values { Array.new(5) { TestMethods.random_string(10) } }
    default_value { allowed_values.sample(rand((min_size || 0)..(max_size || allowed_values.size))) }
  end

  factory :integer_active_field, parent: :active_field, class: "ActiveFields::Field::Integer" do
    type { "ActiveFields::Field::Integer" }
  end

  factory :integer_array_active_field, parent: :active_field, class: "ActiveFields::Field::IntegerArray" do
    type { "ActiveFields::Field::IntegerArray" }
  end

  factory :decimal_active_field, parent: :active_field, class: "ActiveFields::Field::Decimal" do
    type { "ActiveFields::Field::Decimal" }
  end

  factory :decimal_array_active_field, parent: :active_field, class: "ActiveFields::Field::DecimalArray" do
    type { "ActiveFields::Field::DecimalArray" }
  end

  factory :date_active_field, parent: :active_field, class: "ActiveFields::Field::Date" do
    type { "ActiveFields::Field::Date" }
  end

  factory :date_array_active_field, parent: :active_field, class: "ActiveFields::Field::DateArray" do
    type { "ActiveFields::Field::DateArray" }
  end

  factory :boolean_active_field, parent: :active_field, class: "ActiveFields::Field::Boolean" do
    type { "ActiveFields::Field::Boolean" }

    default_value do
      allowed = [true]
      allowed << false unless required
      allowed << nil if nullable

      allowed.sample
    end
  end

  # ActiveField::Value
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
