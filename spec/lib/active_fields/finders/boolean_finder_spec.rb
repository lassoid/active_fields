# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::BooleanFinder do
  subject(:perform_search) { described_class.new(active_field: active_field).search(operator: operator, value: value) }

  let!(:active_field) { create(:boolean_active_field, :nullable) }

  let!(:records) do
    [
      create(active_value_factory, active_field: active_field, value: true),
      create(active_value_factory, active_field: active_field, value: false),
      create(active_value_factory, active_field: active_field, value: nil),
    ]
  end

  context "with eq operator" do
    let(:operator) { ["=", :"=", "eq", :eq].sample }

    context "when value is true" do
      let(:value) { [true, "true"].sample }

      it { is_expected.to include(*records.select { _1.value.is_a?(TrueClass) }) }
      it { is_expected.to exclude(*records.reject { _1.value.is_a?(TrueClass) }) }
    end

    context "when value is false" do
      let(:value) { [false, "false"].sample }

      it { is_expected.to include(*records.select { _1.value.is_a?(FalseClass) }) }
      it { is_expected.to exclude(*records.reject { _1.value.is_a?(FalseClass) }) }
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it { is_expected.to include(*records.select { _1.value.nil? }) }
      it { is_expected.to exclude(*records.reject { _1.value.nil? }) }
    end
  end

  context "with not_eq operator" do
    let(:operator) { ["!=", :"!=", "not_eq", :not_eq].sample }

    context "when value is true" do
      let(:value) { [true, "true"].sample }

      it { is_expected.to include(*records.reject { _1.value.is_a?(TrueClass) }) }
      it { is_expected.to exclude(*records.select { _1.value.is_a?(TrueClass) }) }
    end

    context "when value is false" do
      let(:value) { [false, "false"].sample }

      it { is_expected.to include(*records.reject { _1.value.is_a?(FalseClass) }) }
      it { is_expected.to exclude(*records.select { _1.value.is_a?(FalseClass) }) }
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it { is_expected.to include(*records.reject { _1.value.nil? }) }
      it { is_expected.to exclude(*records.select { _1.value.nil? }) }
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
