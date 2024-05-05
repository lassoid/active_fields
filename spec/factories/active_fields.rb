# frozen_string_literal: true

FactoryBot.define do
  factory :active_field, class: "ActiveFields::Field" do
    sequence(:name) { |n| "field_#{n}" }

    customizable_type { %w[Post Comment].sample }
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
      min_length = [record.min_length, 0].compact.max
      max_length = record.max_length && record.max_length >= min_length ? record.max_length : min_length + rand(0..10)

      allowed = [TestMethods.random_string(rand(min_length..max_length))]
      allowed << nil unless record.required?

      record.default_value = allowed.sample
    end
  end

  factory :text_array_active_field, parent: :active_field, class: "ActiveFields::Field::TextArray" do
    type { "ActiveFields::Field::TextArray" }

    trait :with_min_size do
      min_size { rand(0..5) }
    end

    trait :with_max_size do
      max_size { rand(5..10) }
    end

    trait :with_min_length do
      min_length { rand(0..10) }
    end

    trait :with_max_length do
      max_length { rand(10..20) }
    end

    after(:build) do |record|
      min_length = [record.min_length, 0].compact.max
      max_length = record.max_length && record.max_length >= min_length ? record.max_length : min_length + rand(0..10)

      min_size = [record.min_size, 0].compact.max
      max_size = record.max_size && record.max_size >= min_size ? record.max_size : min_size + rand(0..10)

      record.default_value = Array.new(rand(min_size..max_size)) do
        TestMethods.random_string(rand(min_length..max_length))
      end
    end
  end

  factory :enum_active_field, parent: :active_field, class: "ActiveFields::Field::Enum" do
    type { "ActiveFields::Field::Enum" }

    allowed_values { Array.new(rand(1..5)) { TestMethods.random_string } }

    trait :required do
      required { true }
    end

    after(:build) do |record|
      allowed = record.allowed_values.dup || []
      allowed << nil unless record.required?

      record.default_value = allowed.sample
    end
  end

  factory :enum_array_active_field, parent: :active_field, class: "ActiveFields::Field::EnumArray" do
    type { "ActiveFields::Field::EnumArray" }

    trait :with_min_size do
      min_size { rand(0..5) }
    end

    trait :with_max_size do
      max_size { rand(5..10) }
    end

    after(:build) do |record|
      min_size = [record.min_size, 0].compact.max
      max_size = record.max_size && record.max_size >= min_size ? record.max_size : min_size + rand(0..10)

      record.allowed_values = Array.new([max_size + rand(0..5), 1].max) { TestMethods.random_string }

      record.default_value = record.allowed_values.sample(rand(min_size..max_size))
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
      min = record.min || ((record.max || 0) - rand(0..10))
      max = record.max && record.max >= min ? record.max : min + rand(0..10)

      allowed = [rand(min..max)]
      allowed << nil unless record.required?

      record.default_value = allowed.sample
    end
  end

  factory :integer_array_active_field, parent: :active_field, class: "ActiveFields::Field::IntegerArray" do
    type { "ActiveFields::Field::IntegerArray" }

    trait :with_min_size do
      min_size { rand(0..5) }
    end

    trait :with_max_size do
      max_size { rand(5..10) }
    end

    trait :with_min do
      min { rand(-10..0) }
    end

    trait :with_max do
      max { rand(0..10) }
    end

    after(:build) do |record|
      min = record.min || ((record.max || 0) - rand(0..10))
      max = record.max && record.max >= min ? record.max : min + rand(0..10)

      min_size = [record.min_size, 0].compact.max
      max_size = record.max_size && record.max_size >= min_size ? record.max_size : min_size + rand(0..10)

      record.default_value = Array.new(rand(min_size..max_size)) { rand(min..max) }
    end
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
      min = record.min || ((record.max || 0) - rand(0.0..10.0))
      max = record.max && record.max >= min ? record.max : min + rand(0.0..10.0)

      allowed = [rand(min..max)]
      allowed << nil unless record.required?

      record.default_value = allowed.sample
    end
  end

  factory :decimal_array_active_field, parent: :active_field, class: "ActiveFields::Field::DecimalArray" do
    type { "ActiveFields::Field::DecimalArray" }

    trait :with_min_size do
      min_size { rand(0..5) }
    end

    trait :with_max_size do
      max_size { rand(5..10) }
    end

    trait :with_min do
      min { rand(-10.0..0.0) }
    end

    trait :with_max do
      max { rand(0.0..10.0) }
    end

    after(:build) do |record|
      min = record.min || ((record.max || 0) - rand(0.0..10.0))
      max = record.max && record.max >= min ? record.max : min + rand(0.0..10.0)

      min_size = [record.min_size, 0].compact.max
      max_size = record.max_size && record.max_size >= min_size ? record.max_size : min_size + rand(0..10)

      record.default_value = Array.new(rand(min_size..max_size)) { rand(min..max) }
    end
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
      min = record.min || ((record.max || Date.today) - rand(0..10))
      max = record.max && record.max >= min ? record.max : min + rand(0..10)

      allowed = [rand(min..max)]
      allowed << nil unless record.required?

      record.default_value = allowed.sample
    end
  end

  factory :date_array_active_field, parent: :active_field, class: "ActiveFields::Field::DateArray" do
    type { "ActiveFields::Field::DateArray" }

    trait :with_min_size do
      min_size { rand(0..5) }
    end

    trait :with_max_size do
      max_size { rand(5..10) }
    end

    trait :with_min do
      min { Date.today + rand(-10..0) }
    end

    trait :with_max do
      max { Date.today + rand(0..10) }
    end

    after(:build) do |record|
      min = record.min || ((record.max || Date.today) - rand(0..10))
      max = record.max && record.max >= min ? record.max : min + rand(0..10)

      min_size = [record.min_size, 0].compact.max
      max_size = record.max_size && record.max_size >= min_size ? record.max_size : min_size + rand(0..10)

      record.default_value = Array.new(rand(min_size..max_size)) { rand(min..max) }
    end
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
