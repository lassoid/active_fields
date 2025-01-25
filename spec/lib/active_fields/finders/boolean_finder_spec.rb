# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::BooleanFinder do
  describe "#search" do
    subject(:perform_search) do
      described_class.new(active_field: active_field).search(operator: operator, value: value)
    end

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

    context "with symbol provided" do
      let(:operator) { described_class.__operators__.keys.sample.to_sym }

      it "returns operation name for given operator" do
        expect(call_method)
          .to eq(described_class.__operations__.find { |_name, operators| operators.include?(operator.to_s) }.first)
      end
    end

    context "with string provided" do
      let(:operator) { described_class.__operators__.keys.sample.to_s }

      it "returns operation name for given operator" do
        expect(call_method)
          .to eq(described_class.__operations__.find { |_name, operators| operators.include?(operator) }.first)
      end
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
