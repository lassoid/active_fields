# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::EnumFinder do
  subject(:perform_search) { described_class.new(active_field: active_field).search(operator: operator, value: value) }

  let!(:active_field) { create(:enum_active_field) }
  let(:saved_value) { active_field.allowed_values.first }

  let!(:records) do
    active_field.allowed_values.map { create(active_value_factory, active_field: active_field, value: _1) } +
      [create(active_value_factory, active_field: active_field, value: nil)]
  end

  context "with eq operator" do
    let(:operator) { ["=", :"=", "eq", :eq].sample }

    context "when value is a valid option" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.select { _1.value == saved_value }) }
      it { is_expected.to exclude(*records.reject { _1.value == saved_value }) }
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it { is_expected.to include(*records.select { _1.value.nil? }) }
      it { is_expected.to exclude(*records.reject { _1.value.nil? }) }
    end

    context "when value is an invalid option" do
      let(:value) { "invalid" }

      it { is_expected.to exclude(*records) }
    end
  end

  context "with not_eq operator" do
    let(:operator) { ["!=", :"!=", "not_eq", :not_eq].sample }

    context "when value is a valid option" do
      let(:value) { saved_value }

      it { is_expected.to include(*records.reject { _1.value == saved_value }) }
      it { is_expected.to exclude(*records.select { _1.value == saved_value }) }
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it { is_expected.to include(*records.reject { _1.value.nil? }) }
      it { is_expected.to exclude(*records.select { _1.value.nil? }) }
    end

    context "when value is an invalid option" do
      let(:value) { "invalid" }

      it { is_expected.to include(*records) }
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
