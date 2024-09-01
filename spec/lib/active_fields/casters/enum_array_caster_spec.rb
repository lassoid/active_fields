# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::EnumArrayCaster do
  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when array of nils" do
      let(:value) { [nil, nil] }

      it { is_expected.to eq(value) }
    end

    context "when array of numbers" do
      let(:value) { random_numbers }

      it { is_expected.to eq(value.map(&:to_s)) }
    end

    context "when array with blank strings" do
      let(:value) { ["", "   "] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of strings" do
      let(:value) { [random_string, random_string] }

      it { is_expected.to eq(value) }
    end

    context "when not an array" do
      let(:value) { random_string }

      it { is_expected.to be_nil }
    end
  end

  describe "#deserialize" do
    subject(:call_method) { object.deserialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when array of nils" do
      let(:value) { [nil, nil] }

      it { is_expected.to eq(value) }
    end

    context "when array of numbers" do
      let(:value) { random_numbers }

      it { is_expected.to eq(value.map(&:to_s)) }
    end

    context "when array with blank strings" do
      let(:value) { ["", "   "] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of strings" do
      let(:value) { [random_string, random_string] }

      it { is_expected.to eq(value) }
    end

    context "when not an array" do
      let(:value) { random_string }

      it { is_expected.to be_nil }
    end
  end
end
