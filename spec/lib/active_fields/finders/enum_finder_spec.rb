# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::EnumFinder do
  subject(:perform_search) { described_class.new(active_field: active_field).search(operator: operator, value: value) }

  let!(:active_field) { create(:enum_active_field) }
  let(:saved_value) { active_field.allowed_values.first }

  let!(:records) do
    [
      *active_field.allowed_values,
      nil,
    ].map do |value|
      create(active_value_factory, active_field: active_field, value: value)
    end
  end

  context "with eq operator" do
    let(:operator) { ["=", :"=", "eq", :eq].sample }

    context "when value is a valid option" do
      let(:value) { saved_value }

      it "returns only records with such value" do
        expect(perform_search)
          .to include(*records.select { _1.value == saved_value })
          .and exclude(*records.reject { _1.value == saved_value })
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

    context "when value is an invalid option" do
      let(:value) { "invalid" }

      it "returns no records" do
        expect(perform_search).to exclude(*records)
      end
    end
  end

  context "with not_eq operator" do
    let(:operator) { ["!=", :"!=", "not_eq", :not_eq].sample }

    context "when value is a valid option" do
      let(:value) { saved_value }

      it "returns all records except with such value" do
        expect(perform_search)
          .to include(*records.reject { _1.value == saved_value })
          .and exclude(*records.select { _1.value == saved_value })
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

    context "when value is an invalid option" do
      let(:value) { "invalid" }

      it "returns all records" do
        expect(perform_search).to include(*records)
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
