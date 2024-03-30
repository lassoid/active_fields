# frozen_string_literal: true

RSpec.describe ActiveFields::Validators::TextValidator do
  subject(:validate) { object.validate(value) }

  multiple_max_size = 5
  max_length = 20
  let(:object) { described_class.new(active_field) }
  let(:active_field) do
    build(:text_active_field, multiple:, required:, allowed_values:, multiple_max_size:, max_length:)
  end

  context "when not multiple" do
    let(:multiple) { false }

    context "when not required" do
      let(:required) { false }

      context "when doesn't have allowed values" do
        let(:allowed_values) { [] }

        include_examples "custom_field_validate", nil, "nil"
        include_examples "custom_field_validate", "", "a blank string"
        include_examples "custom_field_validate", "a" * max_length, "a string"
        include_examples "custom_field_validate",
          "a" * (max_length + 1),
          "a string with exceeded length",
          [[:too_long, count: max_length]]
        include_examples "custom_field_validate",
          [rand(0..10), Date.current, ["test value"]].sample,
          "not a string or nil",
          [:invalid]
      end

      context "when has allowed values" do
        let(:allowed_values) { ["allowed", "other allowed"] }

        include_examples "custom_field_validate", nil, "nil"
        include_examples "custom_field_validate", "", "a blank string"
        include_examples "custom_field_validate", "not allowed", "not an allowed string", [:inclusion]
        include_examples "custom_field_validate", "allowed", "an allowed string"
        include_examples "custom_field_validate",
          [rand(0..10), Date.current, ["test value"]].sample,
          "not a string or nil",
          [:invalid]
      end
    end

    context "when required" do
      let(:required) { true }

      context "when doesn't have allowed values" do
        let(:allowed_values) { [] }

        include_examples "custom_field_validate", nil, "nil", [:blank]
        include_examples "custom_field_validate", "", "a blank string", [:blank]
        include_examples "custom_field_validate", "a" * max_length, "a string"
        include_examples "custom_field_validate",
          "a" * (max_length + 1),
          "a string with exceeded length",
          [[:too_long, count: max_length]]
        include_examples "custom_field_validate",
          [rand(0..10), Date.current, ["test value"]].sample,
          "not a string or nil",
          [:invalid]
      end

      context "when has allowed values" do
        let(:allowed_values) { ["allowed", "other allowed"] }

        include_examples "custom_field_validate", nil, "nil", [:blank]
        include_examples "custom_field_validate", "", "a blank string", [:blank]
        include_examples "custom_field_validate", "not allowed", "not an allowed string", [:inclusion]
        include_examples "custom_field_validate", "allowed", "an allowed string"
        include_examples "custom_field_validate",
          [rand(0..10), Date.current, ["test value"]].sample,
          "not a string or nil",
          [:invalid]
      end
    end
  end

  context "when multiple" do
    let(:multiple) { true }

    context "when not required" do
      let(:required) { false }

      context "when doesn't have allowed values" do
        let(:allowed_values) { [] }

        include_examples "custom_field_validate", [], "an empty array"
        include_examples "custom_field_validate", ["", " "], "an array of blank strings"
        include_examples "custom_field_validate", ["", "test value"], "an array containing a blank string"
        include_examples "custom_field_validate", ["valid", "a" * max_length], "an array of strings"
        include_examples "custom_field_validate",
          ["valid", "a" * (max_length + 1)],
          "an array containing a string with exceeded length",
          [[:too_long, count: max_length]]
        include_examples "custom_field_validate", Array.new(multiple_max_size, &:to_s), "an array of strings"
        include_examples "custom_field_validate",
          Array.new(multiple_max_size + 1, &:to_s),
          "an array of strings with exceeded size",
          [[:size_too_long, count: multiple_max_size]]
        include_examples "custom_field_validate",
          ["test value", ["test value", nil], ["test value", 1]].sample,
          "not an array of strings",
          [:invalid]
      end

      context "when has allowed values" do
        let(:allowed_values) { ["allowed", "other allowed"] }

        include_examples "custom_field_validate", [], "an empty array"
        include_examples "custom_field_validate", ["", " "], "an array of blank strings", [:inclusion]
        include_examples "custom_field_validate", ["", "allowed"], "an array containing a blank string", [:inclusion]
        include_examples "custom_field_validate", ["allowed"], "an array with allowed strings"
        include_examples "custom_field_validate",
          ["allowed", "not allowed"],
          "an array containing a not allowed string",
          [:inclusion]
        include_examples "custom_field_validate",
          ["test value", ["test value", nil], ["test value", 1]].sample,
          "not an array of strings",
          [:invalid]
      end
    end

    context "when required" do
      let(:required) { true }

      context "when doesn't have allowed values" do
        let(:allowed_values) { [] }

        include_examples "custom_field_validate", [], "empty array", [:blank]
        include_examples "custom_field_validate", ["", " "], "an array of blank strings", [:blank]
        include_examples "custom_field_validate", ["", "test value"], "an array containing a blank string"
        include_examples "custom_field_validate", ["valid", "a" * max_length], "an array of strings"
        include_examples "custom_field_validate",
          ["valid", "a" * (max_length + 1)],
          "an array containing a string with exceeded length",
          [[:too_long, count: max_length]]
        include_examples "custom_field_validate", Array.new(multiple_max_size, &:to_s), "an array of strings"
        include_examples "custom_field_validate",
          Array.new(multiple_max_size + 1, &:to_s),
          "an array of strings with exceeded size",
          [[:size_too_long, count: multiple_max_size]]
        include_examples "custom_field_validate",
          ["test value", ["test value", nil], ["test value", 1]].sample,
          "not an array of strings",
          [:invalid]
      end

      context "when has allowed values" do
        let(:allowed_values) { ["allowed", "other allowed"] }

        include_examples "custom_field_validate", [], "an empty array", [:blank]
        include_examples "custom_field_validate", ["", " "], "an array of blank strings", %i[inclusion blank]
        include_examples "custom_field_validate", ["", "allowed"], "an array containing a blank string", [:inclusion]
        include_examples "custom_field_validate", ["allowed"], "an array with allowed strings"
        include_examples "custom_field_validate",
          ["allowed", "not allowed"],
          "an array containing a not allowed string",
          [:inclusion]
        include_examples "custom_field_validate",
          ["test value", ["test value", nil], ["test value", 1]].sample,
          "not an array of strings",
          [:invalid]
      end
    end
  end
end
