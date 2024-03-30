# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ActiveFields::Validators::IntegerValidator do
  subject(:validate) { object.validate(value) }

  multiple_max_size = 5
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(:integer_active_field, multiple:, required:, min:, max:, multiple_max_size:) }

  context "when not multiple" do
    let(:multiple) { false }

    context "when not required" do
      let(:required) { false }

      context "without min and max" do
        let(:min) { nil }
        let(:max) { nil }

        include_examples "custom_field_validate", nil, "nil"
        include_examples "custom_field_validate", rand(1..20), "a number"
        include_examples "custom_field_validate",
          ["invalid", Date.current, [3]].sample,
          "not a number or nil",
          [:invalid]
      end

      context "with min" do
        min = rand(1..10)
        let(:min) { min }
        let(:max) { nil }

        include_examples "custom_field_validate", nil, "nil"
        include_examples "custom_field_validate", min, "an allowed minimum"
        include_examples "custom_field_validate", min + 1, "a number greater than minimum"
        include_examples "custom_field_validate",
          min - 1,
          "a number less than minimum",
          [[:greater_than_or_equal_to, count: min]]
        include_examples "custom_field_validate",
          ["invalid", Date.current, [3]].sample,
          "not a number or nil",
          [:invalid]
      end

      context "with max" do
        max = rand(11..20)
        let(:min) { nil }
        let(:max) { max }

        include_examples "custom_field_validate", nil, "nil"
        include_examples "custom_field_validate", max, "an allowed maximum"
        include_examples "custom_field_validate", max - 1, "a number less than maximum"
        include_examples "custom_field_validate",
          max + 1,
          "a number greater than maximum",
          [[:less_than_or_equal_to, count: max]]
        include_examples "custom_field_validate",
          ["invalid", Date.current, [3]].sample,
          "not a number or nil",
          [:invalid]
      end

      context "with both min and max" do
        min = rand(1..10)
        max = rand(11..20)
        let(:min) { min }
        let(:max) { max }

        include_examples "custom_field_validate", nil, "nil"
        include_examples "custom_field_validate", min, "an allowed minimum"
        include_examples "custom_field_validate", max, "an allowed maximum"
        include_examples "custom_field_validate", rand(min..max), "a number between minimum and maximum"
        include_examples "custom_field_validate",
          min - 1,
          "a number less than minimum",
          [[:greater_than_or_equal_to, count: min]]
        include_examples "custom_field_validate",
          max + 1,
          "a number greater than maximum",
          [[:less_than_or_equal_to, count: max]]
        include_examples "custom_field_validate",
          ["invalid", Date.current, [3]].sample,
          "not a number or nil",
          [:invalid]
      end
    end

    context "when required" do
      let(:required) { true }

      context "without min and max" do
        let(:min) { nil }
        let(:max) { nil }

        include_examples "custom_field_validate", nil, "nil", [:blank]
        include_examples "custom_field_validate", rand(1..20), "a number"
        include_examples "custom_field_validate",
          ["invalid", Date.current, [3]].sample,
          "not a number or nil",
          [:invalid]
      end

      context "with min" do
        min = rand(1..10)
        let(:min) { min }
        let(:max) { nil }

        include_examples "custom_field_validate", nil, "nil", [:blank]
        include_examples "custom_field_validate", min, "an allowed minimum"
        include_examples "custom_field_validate", min + 1, "a number greater than minimum"
        include_examples "custom_field_validate",
          min - 1,
          "a number less than minimum",
          [[:greater_than_or_equal_to, count: min]]
        include_examples "custom_field_validate",
          ["invalid", Date.current, [3]].sample,
          "not a number or nil",
          [:invalid]
      end

      context "with max" do
        max = rand(11..20)
        let(:min) { nil }
        let(:max) { max }

        include_examples "custom_field_validate", nil, "nil", [:blank]
        include_examples "custom_field_validate", max, "an allowed maximum"
        include_examples "custom_field_validate", max - 1, "a number less than maximum"
        include_examples "custom_field_validate",
          max + 1,
          "a number greater than maximum",
          [[:less_than_or_equal_to, count: max]]
        include_examples "custom_field_validate",
          ["invalid", Date.current, [3]].sample,
          "not a number or nil",
          [:invalid]
      end

      context "with both min and max" do
        min = rand(1..10)
        max = rand(11..20)
        let(:min) { min }
        let(:max) { max }

        include_examples "custom_field_validate", nil, "nil", [:blank]
        include_examples "custom_field_validate", min, "an allowed minimum"
        include_examples "custom_field_validate", max, "an allowed maximum"
        include_examples "custom_field_validate", rand(min..max), "a number between minimum and maximum"
        include_examples "custom_field_validate",
          min - 1,
          "a number less than minimum",
          [[:greater_than_or_equal_to, count: min]]
        include_examples "custom_field_validate",
          max + 1,
          "a number greater than maximum",
          [[:less_than_or_equal_to, count: max]]
        include_examples "custom_field_validate",
          ["invalid", Date.current, [3]].sample,
          "not a number or nil",
          [:invalid]
      end
    end
  end

  context "when multiple" do
    let(:multiple) { true }

    context "when not required" do
      let(:required) { false }

      context "without min and max" do
        let(:min) { nil }
        let(:max) { nil }

        include_examples "custom_field_validate", [], "an empty array"
        include_examples "custom_field_validate", Array.new(multiple_max_size, &:to_i), "an array of numbers"
        include_examples "custom_field_validate",
          Array.new(multiple_max_size + 1, &:to_i),
          "an array of numbers with exceeded size",
          [[:size_too_long, count: multiple_max_size]]
        include_examples "custom_field_validate",
          [1, [33, nil], ["test value", 7]].sample,
          "not an array of numbers",
          [:invalid]
      end

      context "with min" do
        min = rand(1..10)
        let(:min) { min }
        let(:max) { nil }

        include_examples "custom_field_validate", [], "an empty array"
        include_examples "custom_field_validate", [min, min + 1], "an array of allowed numbers"
        include_examples "custom_field_validate",
          [min, min - 1],
          "an array containing a number less than minimum",
          [[:greater_than_or_equal_to, count: min]]
        include_examples "custom_field_validate",
          [1, [33, nil], ["test value", 7]].sample,
          "not an array of numbers",
          [:invalid]
      end

      context "with max" do
        max = rand(11..20)
        let(:min) { nil }
        let(:max) { max }

        include_examples "custom_field_validate", [], "an empty array"
        include_examples "custom_field_validate", [max, max - 1], "an array of allowed numbers"
        include_examples "custom_field_validate",
          [max, max + 1],
          "an array containing a number greater than maximum",
          [[:less_than_or_equal_to, count: max]]
        include_examples "custom_field_validate",
          [1, [33, nil], ["test value", 7]].sample,
          "not an array of numbers",
          [:invalid]
      end

      context "with both min and max" do
        min = rand(1..10)
        max = rand(11..20)
        let(:min) { min }
        let(:max) { max }

        include_examples "custom_field_validate", [], "an empty array"
        include_examples "custom_field_validate", [rand(min..max), rand(min..max)], "an array of allowed numbers"
        include_examples "custom_field_validate",
          [max, min - 1],
          "an array containing a number less than minimum",
          [[:greater_than_or_equal_to, count: min]]
        include_examples "custom_field_validate",
          [min, max + 1],
          "an array containing a number greater than maximum",
          [[:less_than_or_equal_to, count: max]]
        include_examples "custom_field_validate",
          [1, [33, nil], ["test value", 7]].sample,
          "not an array of numbers",
          [:invalid]
      end
    end

    context "when required" do
      let(:required) { true }

      context "without min and max" do
        let(:min) { nil }
        let(:max) { nil }

        include_examples "custom_field_validate", [], "an empty array", [:blank]
        include_examples "custom_field_validate", Array.new(multiple_max_size, &:to_i), "an array of numbers"
        include_examples "custom_field_validate",
          Array.new(multiple_max_size + 1, &:to_i),
          "an array of numbers with exceeded size",
          [[:size_too_long, count: multiple_max_size]]
        include_examples "custom_field_validate",
          [1, [33, nil], ["test value", 7]].sample,
          "not an array of numbers",
          [:invalid]
      end

      context "with min" do
        min = rand(1..10)
        let(:min) { min }
        let(:max) { nil }

        include_examples "custom_field_validate", [], "an empty array", [:blank]
        include_examples "custom_field_validate", [min, min + 1], "an array of allowed numbers"
        include_examples "custom_field_validate",
          [min, min - 1],
          "an array containing a number less than minimum",
          [[:greater_than_or_equal_to, count: min]]
        include_examples "custom_field_validate",
          [1, [33, nil], ["test value", 7]].sample,
          "not an array of numbers",
          [:invalid]
      end

      context "with max" do
        max = rand(11..20)
        let(:min) { nil }
        let(:max) { max }

        include_examples "custom_field_validate", [], "an empty array", [:blank]
        include_examples "custom_field_validate", [max, max - 1], "an array of allowed numbers"
        include_examples "custom_field_validate",
          [max, max + 1],
          "an array containing a number greater than maximum",
          [[:less_than_or_equal_to, count: max]]
        include_examples "custom_field_validate",
          [1, [33, nil], ["test value", 7]].sample,
          "not an array of numbers",
          [:invalid]
      end

      context "with both min and max" do
        min = rand(1..10)
        max = rand(11..20)
        let(:min) { min }
        let(:max) { max }

        include_examples "custom_field_validate", [], "an empty array", [:blank]
        include_examples "custom_field_validate", [rand(min..max), rand(min..max)], "an array of allowed numbers"
        include_examples "custom_field_validate",
          [max, min - 1],
          "an array containing a number less than minimum",
          [[:greater_than_or_equal_to, count: min]]
        include_examples "custom_field_validate",
          [min, max + 1],
          "an array containing a number greater than maximum",
          [[:less_than_or_equal_to, count: max]]
        include_examples "custom_field_validate",
          [1, [33, nil], ["test value", 7]].sample,
          "not an array of numbers",
          [:invalid]
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
