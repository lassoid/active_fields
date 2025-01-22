# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::TextArrayFinder do
  describe "#search" do
    subject(:perform_search) do
      described_class.new(active_field: active_field).search(operator: operator, value: value)
    end

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

  describe "##operators_for" do
    subject(:call_method) { described_class.operators_for(operation_name) }

    context "with symbol provided" do
      let(:operation_name) { described_class.operations.sample.to_sym }

      it "returns declared operators for given operation name" do
        expect(call_method).to eq(described_class.__operations__[operation_name])
      end
    end

    context "with string provided" do
      let(:operation_name) { described_class.operations.sample.to_s }

      it "returns declared operators for given operation name" do
        expect(call_method).to eq(described_class.__operations__[operation_name.to_sym])
      end
    end

    context "when such operation doesn't exist" do
      let(:operation_name) { "invalid" }

      it { is_expected.to be_nil }
    end
  end

  describe "##operation_for" do
    subject(:call_method) { described_class.operation_for(operator) }

    let(:operator) { described_class.__operators__.keys.sample }

    it "returns operation name for given operator" do
      expect(call_method)
        .to eq(described_class.__operations__.find { |_name, operators| operators.include?(operator) }.first)
    end

    context "when such operator doesn't exist" do
      let(:operator) { "invalid" }

      it { is_expected.to be_nil }
    end
  end

  describe "##operations" do
    subject(:call_method) { described_class.operations }

    it "returns all declared operations names" do
      expect(call_method).to eq(described_class.__operations__.keys)
    end
  end
end
