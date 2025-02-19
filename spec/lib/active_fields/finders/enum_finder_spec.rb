# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::EnumFinder do
  include_examples "field_finder"

  describe "#search" do
    subject(:perform_search) do
      described_class.new(active_field: active_field).search(op: op, value: value)
    end

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

    context "with eq op" do
      let(:op) { ["=", :"=", "eq", :eq].sample }

      context "when value is a valid option" do
        let(:value) { saved_value }

        it "returns only records with such value" do
          expect(perform_search)
            .to include(*records.select { _1.value == value })
            .and exclude(*records.reject { _1.value == value })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

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

    context "with not_eq op" do
      let(:op) { ["!=", :"!=", "not_eq", :not_eq].sample }

      context "when value is a valid option" do
        let(:value) { saved_value }

        it "returns all records except with such value" do
          expect(perform_search)
            .to include(*records.reject { _1.value == value })
            .and exclude(*records.select { _1.value == value })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

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

    context "with invalid op" do
      let(:op) { "invalid" }
      let(:value) { nil }

      it "returns nil" do
        expect(perform_search).to be_nil
      end
    end
  end
end
