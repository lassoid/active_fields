# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::DateFinder do
  subject(:perform_search) { described_class.new(active_field: active_field).search(operator: operator, value: value) }

  let!(:active_field) { create(:date_active_field) }
  let(:saved_value) { random_date }

  let!(:records) do
    [
      create(active_value_factory, active_field: active_field, value: saved_value),
      create(active_value_factory, active_field: active_field, value: rand(1..10).days.before(saved_value)),
      create(active_value_factory, active_field: active_field, value: rand(1..10).days.after(saved_value)),
      create(active_value_factory, active_field: active_field, value: nil),
    ]
  end

  context "with eq operator" do
    let(:operator) { ["=", :"=", "eq", :eq].sample }

    context "when value is a date" do
      let(:value) { [saved_value, saved_value.iso8601].sample }

      it { is_expected.to include(*records.select { _1.value == saved_value }) }
      it { is_expected.to exclude(*records.reject { _1.value == saved_value }) }
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it { is_expected.to include(*records.select { _1.value.nil? }) }
      it { is_expected.to exclude(*records.reject { _1.value.nil? }) }
    end
  end

  context "with not_eq operator" do
    let(:operator) { ["!=", :"!=", "not_eq", :not_eq].sample }

    context "when value is a date" do
      let(:value) { [saved_value, saved_value.iso8601].sample }

      it { is_expected.to include(*records.reject { _1.value == saved_value }) }
      it { is_expected.to exclude(*records.select { _1.value == saved_value }) }
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it { is_expected.to include(*records.reject { _1.value.nil? }) }
      it { is_expected.to exclude(*records.select { _1.value.nil? }) }
    end
  end

  context "with gt operator" do
    let(:operator) { [">", :">", "gt", :gt].sample }

    context "when value is a date" do
      let(:value) { [saved_value, saved_value.iso8601].sample }

      it { is_expected.to include(*records.select { _1.value && _1.value > saved_value }) }
      it { is_expected.to exclude(*records.reject { _1.value && _1.value > saved_value }) }
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it { is_expected.to exclude(*records) }
    end
  end

  context "with gteq operator" do
    let(:operator) { [">=", :">=", "gteq", :gteq, "gte", :gte].sample }

    context "when value is a date" do
      let(:value) { [saved_value, saved_value.iso8601].sample }

      it { is_expected.to include(*records.select { _1.value && _1.value >= saved_value }) }
      it { is_expected.to exclude(*records.reject { _1.value && _1.value >= saved_value }) }
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it { is_expected.to exclude(*records) }
    end
  end

  context "with lt operator" do
    let(:operator) { ["<", :"<", "lt", :lt].sample }

    context "when value is a date" do
      let(:value) { [saved_value, saved_value.iso8601].sample }

      it { is_expected.to include(*records.select { _1.value && _1.value < saved_value }) }
      it { is_expected.to exclude(*records.reject { _1.value && _1.value < saved_value }) }
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it { is_expected.to exclude(*records) }
    end
  end

  context "with lteq operator" do
    let(:operator) { ["<=", :"<=", "lteq", :lteq, "lte", :lte].sample }

    context "when value is a date" do
      let(:value) { [saved_value, saved_value.iso8601].sample }

      it { is_expected.to include(*records.select { _1.value && _1.value <= saved_value }) }
      it { is_expected.to exclude(*records.reject { _1.value && _1.value <= saved_value }) }
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it { is_expected.to exclude(*records) }
    end
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
