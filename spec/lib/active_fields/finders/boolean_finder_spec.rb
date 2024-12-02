# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::BooleanFinder do
  subject(:perform_search) { described_class.new(active_field: active_field).search(operator: operator, value: value) }

  let!(:active_field) { create(:boolean_active_field, :nullable) }

  let!(:records) do
    [true, false, nil].map do |value|
      create(active_value_factory, active_field: active_field, value: value)
    end
  end

  context "with eq operator" do
    let(:operator) { ["=", :"=", "eq", :eq].sample }

    context "when value is true" do
      let(:value) { [true, "true"].sample }

      it "returns only records with truthy value" do
        expect(perform_search)
          .to include(*records.select { _1.value.is_a?(TrueClass) })
          .and exclude(*records.reject { _1.value.is_a?(TrueClass) })
      end
    end

    context "when value is false" do
      let(:value) { [false, "false"].sample }

      it "returns only records with falsy value" do
        expect(perform_search)
          .to include(*records.select { _1.value.is_a?(FalseClass) })
          .and exclude(*records.reject { _1.value.is_a?(FalseClass) })
      end
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it "returns only records with null value" do
        expect(perform_search)
          .to include(*records.select { _1.value.nil? })
          .and exclude(*records.reject { _1.value.nil? })
      end
    end
  end

  context "with not_eq operator" do
    let(:operator) { ["!=", :"!=", "not_eq", :not_eq].sample }

    context "when value is true" do
      let(:value) { [true, "true"].sample }

      it "returns only records with not truthy value" do
        expect(perform_search)
          .to include(*records.reject { _1.value.is_a?(TrueClass) })
          .and exclude(*records.select { _1.value.is_a?(TrueClass) })
      end
    end

    context "when value is false" do
      let(:value) { [false, "false"].sample }

      it "returns only records with not falsy value" do
        expect(perform_search)
          .to include(*records.reject { _1.value.is_a?(FalseClass) })
          .and exclude(*records.select { _1.value.is_a?(FalseClass) })
      end
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it "returns only records with not null value" do
        expect(perform_search)
          .to include(*records.reject { _1.value.nil? })
          .and exclude(*records.select { _1.value.nil? })
      end
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
