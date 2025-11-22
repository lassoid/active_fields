# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::DateFinder do
  it_behaves_like "field_finder"

  describe "#search" do
    subject(:perform_search) do
      described_class.new(active_field: active_field).search(op: op, value: value)
    end

    let!(:active_field) { create(:date_active_field) }
    let(:saved_value) { random_date }

    let!(:records) do
      [
        saved_value,
        rand(1..10).days.before(saved_value),
        rand(1..10).days.after(saved_value),
        nil,
      ].map do |value|
        create(active_value_factory, active_field: active_field, value: value)
      end
    end

    context "with eq op" do
      let(:op) { ["=", :"=", "eq", :eq].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns only records with such value" do
          expect(perform_search)
            .to include(*records.select { it.value == saved_value })
            .and exclude(*records.reject { it.value == saved_value })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns only records with null value" do
          expect(perform_search)
            .to include(*records.select { it.value.nil? })
            .and exclude(*records.reject { it.value.nil? })
        end
      end
    end

    context "with not_eq op" do
      let(:op) { ["!=", :"!=", "not_eq", :not_eq].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns all records except with such value" do
          expect(perform_search)
            .to include(*records.reject { it.value == saved_value })
            .and exclude(*records.select { it.value == saved_value })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns only records with not null value" do
          expect(perform_search)
            .to include(*records.reject { it.value.nil? })
            .and exclude(*records.select { it.value.nil? })
        end
      end
    end

    context "with gt op" do
      let(:op) { [">", :">", "gt", :gt].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns records greater than the value" do
          expect(perform_search)
            .to include(*records.select { it.value && it.value > saved_value })
            .and exclude(*records.reject { it.value && it.value > saved_value })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with gteq op" do
      let(:op) { [">=", :">=", "gteq", :gteq].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns records greater than or equal to the value" do
          expect(perform_search)
            .to include(*records.select { it.value && it.value >= saved_value })
            .and exclude(*records.reject { it.value && it.value >= saved_value })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with lt op" do
      let(:op) { ["<", :"<", "lt", :lt].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns records less than the value" do
          expect(perform_search)
            .to include(*records.select { it.value && it.value < saved_value })
            .and exclude(*records.reject { it.value && it.value < saved_value })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with lteq op" do
      let(:op) { ["<=", :"<=", "lteq", :lteq].sample }

      context "when value is a date" do
        let(:value) { [saved_value, saved_value.iso8601].sample }

        it "returns records less than or equal to the value" do
          expect(perform_search)
            .to include(*records.select { it.value && it.value <= saved_value })
            .and exclude(*records.reject { it.value && it.value <= saved_value })
        end
      end

      context "when value is nil" do
        let(:value) { [nil, ""].sample }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with not existing or nil op" do
      let(:op) { ["invalid", nil].sample }
      let(:value) { nil }

      it "returns nil" do
        expect(perform_search).to be_nil
      end
    end
  end
end
