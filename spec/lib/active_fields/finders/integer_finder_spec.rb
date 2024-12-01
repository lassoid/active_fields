# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::IntegerFinder do
  subject(:perform_search) { described_class.new(active_field: active_field).search(operator: operator, value: value) }

  let!(:active_field) { create(:integer_active_field) }
  let(:saved_value) { random_integer }

  let!(:records) do
    [
      saved_value,
      saved_value - 1,
      saved_value + 1,
      saved_value - rand(2..10),
      saved_value + rand(2..10),
      nil,
    ].map do |value|
      create(active_value_factory, active_field: active_field, value: value)
    end
  end

  context "with eq operator" do
    let(:operator) { ["=", :"=", "eq", :eq].sample }

    context "when value is an integer" do
      let(:value) { [saved_value, saved_value.to_s].sample }

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
  end

  context "with not_eq operator" do
    let(:operator) { ["!=", :"!=", "not_eq", :not_eq].sample }

    context "when value is an integer" do
      let(:value) { [saved_value, saved_value.to_s].sample }

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
  end

  context "with gt operator" do
    let(:operator) { [">", :">", "gt", :gt].sample }

    context "when value is an integer" do
      let(:value) { [saved_value, saved_value.to_s].sample }

      it "returns records greater than the value" do
        expect(perform_search)
          .to include(*records.select { _1.value && _1.value > saved_value })
          .and exclude(*records.reject { _1.value && _1.value > saved_value })
      end
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it "returns no records" do
        expect(perform_search).to exclude(*records)
      end
    end
  end

  context "with gteq operator" do
    let(:operator) { [">=", :">=", "gteq", :gteq, "gte", :gte].sample }

    context "when value is an integer" do
      let(:value) { [saved_value, saved_value.to_s].sample }

      it "returns records greater than or equal to the value" do
        expect(perform_search)
          .to include(*records.select { _1.value && _1.value >= saved_value })
          .and exclude(*records.reject { _1.value && _1.value >= saved_value })
      end
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it "returns no records" do
        expect(perform_search).to exclude(*records)
      end
    end
  end

  context "with lt operator" do
    let(:operator) { ["<", :"<", "lt", :lt].sample }

    context "when value is an integer" do
      let(:value) { [saved_value, saved_value.to_s].sample }

      it "returns records less than the value" do
        expect(perform_search)
          .to include(*records.select { _1.value && _1.value < saved_value })
          .and exclude(*records.reject { _1.value && _1.value < saved_value })
      end
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it "returns no records" do
        expect(perform_search).to exclude(*records)
      end
    end
  end

  context "with lteq operator" do
    let(:operator) { ["<=", :"<=", "lteq", :lteq, "lte", :lte].sample }

    context "when value is an integer" do
      let(:value) { [saved_value, saved_value.to_s].sample }

      it "returns records less than or equal to the value" do
        expect(perform_search)
          .to include(*records.select { _1.value && _1.value <= saved_value })
          .and exclude(*records.reject { _1.value && _1.value <= saved_value })
      end
    end

    context "when value is nil" do
      let(:value) { [nil, ""].sample }

      it "returns no records" do
        expect(perform_search).to exclude(*records)
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
