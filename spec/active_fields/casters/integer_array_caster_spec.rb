# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::IntegerArrayCaster do
  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    let(:object) { described_class.new }

    context "when array of nils" do
      let(:value) { [nil, nil] }

      it { is_expected.to eq(value) }
    end

    context "when array of integers" do
      let(:value) { [rand(0..10), rand(0..10)] }

      it { is_expected.to eq(value) }
    end

    context "when array of floats" do
      let(:value) { [rand(0.0..10.0), rand(0.0..10.0)] }

      it { is_expected.to eq(value.map { Integer(_1) }) }
    end

    context "when array of integer strings" do
      let(:value) { [rand(0..10).to_s, rand(0..10).to_s] }

      it { is_expected.to eq(value.map { Integer(_1) }) }
    end

    context "when array of decimal strings" do
      let(:value) { [rand(0.0..10.0).to_s, rand(0.0..10.0).to_s] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of strings" do
      let(:value) { %w[first second] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to eq(value) }
    end

    context "when integer" do
      let(:value) { rand(0..10) }

      it { is_expected.to eq(value) }
    end

    context "when decimal" do
      let(:value) { rand(0.0..10.0) }

      it { is_expected.to eq(value) }
    end

    context "when string with integer" do
      let(:value) { rand(0..10).to_s }

      it { is_expected.to eq(value) }
    end

    context "when string with decimal" do
      let(:value) { rand(0.0..10.0).to_s }

      it { is_expected.to eq(value) }
    end

    context "when string" do
      let(:value) { "test value" }

      it { is_expected.to eq(value) }
    end
  end

  describe "#deserialize" do
    subject(:call_method) { object.deserialize(value) }

    let(:object) { described_class.new }

    context "when array of nils" do
      let(:value) { [nil, nil] }

      it { is_expected.to eq(value) }
    end

    context "when array of integers" do
      let(:value) { [rand(0..10), rand(0..10)] }

      it { is_expected.to eq(value) }
    end

    context "when array of floats" do
      let(:value) { [rand(0.0..10.0), rand(0.0..10.0)] }

      it { is_expected.to eq(value.map { Integer(_1) }) }
    end

    context "when array of integer strings" do
      let(:value) { [rand(0..10).to_s, rand(0..10).to_s] }

      it { is_expected.to eq(value.map { Integer(_1) }) }
    end

    context "when array of decimal strings" do
      let(:value) { [rand(0.0..10.0).to_s, rand(0.0..10.0).to_s] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of strings" do
      let(:value) { %w[first second] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to eq(value) }
    end

    context "when integer" do
      let(:value) { rand(0..10) }

      it { is_expected.to eq(value) }
    end

    context "when decimal" do
      let(:value) { rand(0.0..10.0) }

      it { is_expected.to eq(value) }
    end

    context "when string with integer" do
      let(:value) { rand(0..10).to_s }

      it { is_expected.to eq(value) }
    end

    context "when string with decimal" do
      let(:value) { rand(0.0..10.0).to_s }

      it { is_expected.to eq(value) }
    end

    context "when string" do
      let(:value) { "test value" }

      it { is_expected.to eq(value) }
    end
  end
end
