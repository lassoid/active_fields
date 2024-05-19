# frozen_string_literal: true

FactoryBot.define do
  factory :active_field, class: "ActiveFields::Field" do
    sequence(:name) { |n| "field_#{n}" }

    customizable_type { %w[Post Author].sample }

    after(:build) do |record|
      record.default_value = TestMethods.active_value_for(record)
    end
  end

  factory :text_active_field, parent: :active_field, class: "ActiveFields::Field::Text" do
    type { "ActiveFields::Field::Text" }

    trait :required do
      required { true }
    end

    trait :with_min_length do
      min_length { rand(1..10) }
    end

    trait :with_max_length do
      max_length { rand(10..20) }
    end
  end

  factory :text_array_active_field, parent: :active_field, class: "ActiveFields::Field::TextArray" do
    type { "ActiveFields::Field::TextArray" }

    trait :with_min_size do
      min_size { rand(1..5) }
    end

    trait :with_max_size do
      max_size { rand(5..10) }
    end

    trait :with_min_length do
      min_length { rand(1..10) }
    end

    trait :with_max_length do
      max_length { rand(10..20) }
    end
  end

  factory :enum_active_field, parent: :active_field, class: "ActiveFields::Field::Enum" do
    type { "ActiveFields::Field::Enum" }

    allowed_values { Array.new(rand(1..5)) { TestMethods.random_string } }

    trait :required do
      required { true }
    end
  end

  factory :enum_array_active_field, parent: :active_field, class: "ActiveFields::Field::EnumArray" do
    type { "ActiveFields::Field::EnumArray" }

    allowed_values do
      allowed_min_size = [min_size, 0].compact.max
      allowed_max_size = max_size && max_size >= allowed_min_size ? max_size : allowed_min_size + rand(0..10)

      Array.new(allowed_max_size + rand(1..5)) { TestMethods.random_string }
    end

    trait :with_min_size do
      min_size { rand(1..5) }
    end

    trait :with_max_size do
      max_size { rand(5..10) }
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
  end

  factory :integer_array_active_field, parent: :active_field, class: "ActiveFields::Field::IntegerArray" do
    type { "ActiveFields::Field::IntegerArray" }

    trait :with_min_size do
      min_size { rand(1..5) }
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
  end

  factory :decimal_array_active_field, parent: :active_field, class: "ActiveFields::Field::DecimalArray" do
    type { "ActiveFields::Field::DecimalArray" }

    trait :with_min_size do
      min_size { rand(1..5) }
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
  end

  factory :date_array_active_field, parent: :active_field, class: "ActiveFields::Field::DateArray" do
    type { "ActiveFields::Field::DateArray" }

    trait :with_min_size do
      min_size { rand(1..5) }
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
  end

  factory :boolean_active_field, parent: :active_field, class: "ActiveFields::Field::Boolean" do
    type { "ActiveFields::Field::Boolean" }

    trait :required do
      required { true }
    end

    trait :nullable do
      nullable { true }
    end
  end
end
