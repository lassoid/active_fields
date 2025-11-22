# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::EnumArrayFinder do
  it_behaves_like "field_finder"

  describe "#search" do
    subject(:perform_search) do
      described_class.new(active_field: active_field).search(op: op, value: value)
    end

    let!(:active_field) { create(:enum_array_active_field) }
    let(:saved_value) { active_field.allowed_values.first }

    let!(:records) do
      [
        [saved_value],
        active_field.allowed_values[1..-1].sample(1),
        [saved_value, *active_field.allowed_values[1..-1].sample(1)],
        active_field.allowed_values[1..-1].sample(2),
        [],
      ].map do |value|
        create(active_value_factory, active_field: active_field, value: value)
      end
    end

    context "with include op" do
      let(:op) { ["|=", :"|=", "include", :include].sample }

      context "when value is a valid option" do
        let(:value) { saved_value }

        it "returns only records that contain the value" do
          expect(perform_search)
            .to include(*records.select { |r| r.value.include?(value) })
            .and exclude(*records.reject { |r| r.value.include?(value) })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with not_include op" do
      let(:op) { ["!|=", :"!|=", "not_include", :not_include].sample }

      context "when value is a valid option" do
        let(:value) { saved_value }

        it "returns only records that doesn't contain the value" do
          expect(perform_search)
            .to include(*records.reject { |r| r.value.include?(value) })
            .and exclude(*records.select { |r| r.value.include?(value) })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns all records" do
          expect(perform_search).to include(*records)
        end
      end
    end

    it_behaves_like "finder_array_size"

    context "with not existing or nil op" do
      let(:op) { ["invalid", nil].sample }
      let(:value) { nil }

      it "returns nil" do
        expect(perform_search).to be_nil
      end
    end
  end
end
