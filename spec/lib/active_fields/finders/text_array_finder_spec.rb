# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::TextArrayFinder do
  subject(:perform_search) { described_class.new(active_field: active_field).search(operator: operator, value: value) }

  let!(:active_field) { create(:text_array_active_field) }
  let(:saved_value) { random_string }

  let!(:records) do
    [
      [saved_value],
      [random_string],
      [saved_value, random_string],
      [random_string, random_string],
      [""],
      ["", saved_value],
      ["", random_string],
      ["start_#{random_string}"],
      ["", "start_#{random_string}"],
      [],
    ].map do |value|
      create(active_value_factory, active_field: active_field, value: value)
    end
  end

  context "with include operator" do
    let(:operator) { ["|=", :"|=", "include", :include].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it "returns only records that contain the value" do
        expect(perform_search)
          .to include(*records.select { _1.value.include?(value) })
          .and exclude(*records.reject { _1.value.include?(value) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records that contain the value" do
        expect(perform_search)
          .to include(*records.select { _1.value.include?(value) })
          .and exclude(*records.reject { _1.value.include?(value) })
      end
    end

    context "when value is nil" do
      let(:value) { nil }

      it "returns no records" do
        expect(perform_search).to exclude(*records)
      end
    end
  end

  context "with not_include operator" do
    let(:operator) { ["!|=", :"!|=", "not_include", :not_include].sample }

    context "when value is a string" do
      let(:value) { saved_value }

      it "returns only records that doesn't contain the value" do
        expect(perform_search)
          .to include(*records.reject { _1.value.include?(value) })
          .and exclude(*records.select { _1.value.include?(value) })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns only records that doesn't contain the value" do
        expect(perform_search)
          .to include(*records.reject { _1.value.include?(value) })
          .and exclude(*records.select { _1.value.include?(value) })
      end
    end

    context "when value is nil" do
      let(:value) { nil }

      it "returns all records" do
        expect(perform_search).to include(*records)
      end
    end
  end

  context "with any_start_with operator" do
    let(:operator) { ["|^", :"|^", "any_start_with", :any_start_with].sample }

    context "when value is a string" do
      let(:value) { "start_" }

      it "returns only records that contain any element starting with the value" do
        expect(perform_search)
          .to include(*records.select { _1.value.any? { |elem| elem.start_with?(value) } })
          .and exclude(*records.reject { _1.value.any? { |elem| elem.start_with?(value) } })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns all non-empty records" do
        expect(perform_search)
          .to include(*records.select { _1.value.any? })
          .and exclude(*records.reject { _1.value.any? })
      end
    end

    context "when value is nil" do
      let(:value) { nil }

      it "returns no records" do
        expect(perform_search).to exclude(*records)
      end
    end
  end

  context "with all_start_with operator" do
    let(:operator) { ["&^", :"&^", "all_start_with", :all_start_with].sample }

    context "when value is a string" do
      let(:value) { "start_" }

      it "returns only records that elements start with the value" do
        expect(perform_search)
          .to include(*records.select { _1.value.any? && _1.value.all? { |elem| elem.start_with?(value) } })
          .and exclude(*records.reject { _1.value.any? && _1.value.all? { |elem| elem.start_with?(value) } })
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns all non-empty records" do
        expect(perform_search)
          .to include(*records.select { _1.value.any? })
          .and exclude(*records.reject { _1.value.any? })
      end
    end

    context "when value is nil" do
      let(:value) { nil }

      it "returns no records" do
        expect(perform_search).to exclude(*records)
      end
    end
  end

  include_examples "finder_array_size"

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
