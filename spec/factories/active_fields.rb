# frozen_string_literal: true

FactoryBot.define do
  # ActiveField::Field
  factory :active_field, class: "ActiveFields::Field" do
    sequence(:name) { |n| "field_#{n}" }

    customizable_type { ["Post", "Comment"].sample }
  end

  factory :text_active_field, parent: :active_field, class: "ActiveFields::Field::Text" do
    type { "ActiveFields::Field::Text" }

    trait :required do
      required { true }
    end

    trait :with_min_length do
      min_length { rand(0..10) }
    end

    trait :with_max_length do
      max_length { rand(10..20) }
    end

    after(:build) do |record|
      min_length_allowed = record.min_length || 0
      max_length_allowed = record.max_length || 10
      length = rand(min_length_allowed..max_length_allowed) || 10

      allowed = [TestMethods.random_string(length)]
      allowed << nil unless record.required?

      record.default_value = allowed.sample
    end
  end

  factory :text_array_active_field, parent: :active_field, class: "ActiveFields::Field::TextArray" do
    type { "ActiveFields::Field::TextArray" }
  end

  factory :enum_active_field, parent: :active_field, class: "ActiveFields::Field::Enum" do
    type { "ActiveFields::Field::Enum" }

    allowed_values { Array.new(5) { TestMethods.random_string } }

    trait :required do
      required { true }
    end

    after(:build) do |record|
      allowed = record.allowed_values.is_a?(Array) ? record.allowed_values.dup : []
      allowed << nil unless record.required?

      record.default_value = allowed.sample
    end
  end

  factory :enum_array_active_field, parent: :active_field, class: "ActiveFields::Field::EnumArray" do
    type { "ActiveFields::Field::EnumArray" }

    allowed_values { Array.new(5) { TestMethods.random_string } }

    after(:build) do |record|
      allowed_min_size = record.min_size || 0
      allowed_max_size = record.max_size || record.allowed_values.size

      record.default_value = record.allowed_values.sample(rand(allowed_min_size..allowed_max_size))
    end
  end

  factory :integer_active_field, parent: :active_field, class: "ActiveFields::Field::Integer" do
    type { "ActiveFields::Field::Integer" }

    trait :required do
      required { true }
    end

    trait :with_min do
      min { rand(-10..0) }
    end

    trait :with_max do
      max { rand(0..10) }
    end

    after(:build) do |record|
      max_allowed = record.max || 10
      min_allowed = record.min || (max_allowed - 20)
      value = rand(min_allowed..max_allowed) || 0

      allowed = [value]
      allowed << nil unless record.required?

      record.default_value = allowed.sample
    end
  end

  factory :integer_array_active_field, parent: :active_field, class: "ActiveFields::Field::IntegerArray" do
    type { "ActiveFields::Field::IntegerArray" }
  end

  factory :decimal_active_field, parent: :active_field, class: "ActiveFields::Field::Decimal" do
    type { "ActiveFields::Field::Decimal" }

    trait :required do
      required { true }
    end

    trait :with_min do
      min { rand(-10.0..0.0) }
    end

    trait :with_max do
      max { rand(0.0..10.0) }
    end

    after(:build) do |record|
      max_allowed = record.max || 10.0
      min_allowed = record.min || (max_allowed - 20.0)
      value = rand(min_allowed..max_allowed) || 0.0

      allowed = [value]
      allowed << nil unless record.required?

      record.default_value = allowed.sample
    end
  end

  factory :decimal_array_active_field, parent: :active_field, class: "ActiveFields::Field::DecimalArray" do
    type { "ActiveFields::Field::DecimalArray" }
  end

  factory :date_active_field, parent: :active_field, class: "ActiveFields::Field::Date" do
    type { "ActiveFields::Field::Date" }

    trait :required do
      required { true }
    end

    trait :with_min do
      min { Date.today + rand(-10..0) }
    end

    trait :with_max do
      max { Date.today + rand(0..10) }
    end

    after(:build) do |record|
      max_allowed = record.max || Date.today + 10
      min_allowed = record.min || (max_allowed - 20)
      value = (min_allowed..max_allowed).to_a.sample || Date.today

      allowed = [value]
      allowed << nil unless record.required?

      record.default_value = allowed.sample
    end
  end

  factory :date_array_active_field, parent: :active_field, class: "ActiveFields::Field::DateArray" do
    type { "ActiveFields::Field::DateArray" }
  end

  factory :boolean_active_field, parent: :active_field, class: "ActiveFields::Field::Boolean" do
    type { "ActiveFields::Field::Boolean" }

    trait :required do
      required { true }
    end

    trait :nullable do
      nullable { true }
    end

    after(:build) do |record|
      allowed = [true]
      allowed << false unless record.required?
      allowed << nil if record.nullable?

      record.default_value = allowed.sample
    end
  end
end
