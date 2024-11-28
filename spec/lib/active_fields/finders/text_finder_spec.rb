# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::TextFinder do
  subject(:perform_search) { described_class.new(active_field: active_field).search(operator: operator, value: value) }

  let!(:active_field) { create(:text_active_field) }
  let(:saved_value) { random_string }

  let!(:records) do
    [
      create(active_value_factory, active_field: active_field, value: saved_value),
      create(active_value_factory, active_field: active_field, value: "start_#{saved_value}"),
      create(active_value_factory, active_field: active_field, value: "#{saved_value}_end"),
      create(active_value_factory, active_field: active_field, value: "start_#{saved_value}_end"),
      create(active_value_factory, active_field: active_field, value: random_string),
      create(active_value_factory, active_field: active_field, value: ""),
      create(active_value_factory, active_field: active_field, value: nil),
    ]
  end

  context "with eq operator" do
    let(:operator) { ["=", :"=", "eq", :eq].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.select { _1.value == value }) }
      it { is_expected.to exclude(*records.reject { _1.value == value }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.select { _1.value == value }) }
      it { is_expected.to exclude(*records.reject { _1.value == value }) }
    end

    context "when value is nil" do
      let(:value) { nil }

      it { is_expected.to include(*records.select { _1.value.nil? }) }
      it { is_expected.to exclude(*records.reject { _1.value.nil? }) }
    end
  end

  context "with not_eq operator" do
    let(:operator) { ["!=", :"!=", "not_eq", :not_eq].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.reject { _1.value == value }) }
      it { is_expected.to exclude(*records.select { _1.value == value }) }
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it { is_expected.to include(*records.reject { _1.value == value }) }
      it { is_expected.to exclude(*records.select { _1.value == value }) }
    end

    context "when value is nil" do
      let(:value) { nil }

      it { is_expected.to include(*records.reject { _1.value.nil? }) }
      it { is_expected.to exclude(*records.select { _1.value.nil? }) }
    end
  end

  context "with like operator" do
    let(:operator) { ["~~", :"~~", "like", :like].sample }
  end

  context "with ilike operator" do
    let(:operator) { ["~~*", :"~~*", "ilike", :ilike].sample }
  end

  context "with not_like operator" do
    let(:operator) { ["!~~", :"!~~", "not_like", :not_like].sample }
  end

  context "with not_ilike operator" do
    let(:operator) { ["!~~*", :"!~~*", "not_ilike", :not_ilike].sample }
  end

  context "with start_with operator" do
    let(:operator) { ["^", :"^", "start_with", :start_with].sample }
  end

  context "with end_with operator" do
    let(:operator) { ["$", :"$", "end_with", :end_with].sample }
  end

  context "with contain operator" do
    let(:operator) { ["~", :"~", "contain", :contain].sample }
  end

  context "with not_start_with operator" do
    let(:operator) { ["!^", :"!^", "not_start_with", :not_start_with].sample }
  end

  context "with not_end_with operator" do
    let(:operator) { ["!$", :"!$", "not_end_with", :not_end_with].sample }
  end

  context "with not_contain operator" do
    let(:operator) { ["!~", :"!~", "not_contain", :not_contain].sample }
  end

  context "with ci_start_with operator" do
    let(:operator) { ["^*", :"^*", "ci_start_with", :ci_start_with].sample }
  end

  context "with ci_end_with operator" do
    let(:operator) { ["$*", :"$*", "ci_end_with", :ci_end_with].sample }
  end

  context "with ci_contain operator" do
    let(:operator) { ["~*", :"~*", "ci_contain", :ci_contain].sample }
  end

  context "with ci_not_start_with operator" do
    let(:operator) { ["!^*", :"!^*", "ci_not_start_with", :ci_not_start_with].sample }
  end

  context "with ci_not_end_with operator" do
    let(:operator) { ["!$*", :"!$*", "ci_not_end_with", :ci_not_end_with].sample }
  end

  context "with ci_not_contain operator" do
    let(:operator) { ["!~*", :"!~*", "ci_not_contain", :ci_not_contain].sample }
  end

  context "with invalid operator" do
    let(:operator) { "invalid" }
    let(:value) { nil }

    it "raises an error" do
      expect do
        perform_search
      end.to raise_error(ArgumentError)
    end
  end
end
