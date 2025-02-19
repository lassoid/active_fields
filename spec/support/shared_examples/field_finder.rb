# frozen_string_literal: true

RSpec.shared_examples "field_finder" do
  describe "##operations" do
    subject(:call_method) { described_class.operations }

    it "returns all declared operations names" do
      expect(call_method).to eq(described_class.__operations__.keys)
    end
  end

  describe "##operation_for" do
    subject(:call_method) { described_class.operation_for(operator) }

    context "with symbol provided" do
      let(:operator) { described_class.__operators__.keys.sample.to_sym }

      it "returns operation name for given operator" do
        expect(call_method).to eq(described_class.__operators__[operator])
      end
    end

    context "with string provided" do
      let(:operator) { described_class.__operators__.keys.sample.to_s }

      it "returns operation name for given operator" do
        expect(call_method).to eq(described_class.__operators__[operator.to_sym])
      end
    end

    context "when such operator doesn't exist" do
      let(:operator) { "invalid" }

      it { is_expected.to be_nil }
    end
  end

  describe "##operator_for" do
    subject(:call_method) { described_class.operator_for(operation_name) }

    context "with symbol provided" do
      let(:operation_name) { described_class.operations.sample.to_sym }

      it "returns declared operators for given operation name" do
        expect(call_method).to eq(described_class.__operations__[operation_name][:operator])
      end
    end

    context "with string provided" do
      let(:operation_name) { described_class.operations.sample.to_s }

      it "returns declared operators for given operation name" do
        expect(call_method).to eq(described_class.__operations__[operation_name.to_sym][:operator])
      end
    end

    context "when such operation doesn't exist" do
      let(:operation_name) { "invalid" }

      it { is_expected.to be_nil }
    end
  end
end
