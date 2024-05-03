# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DecimalArrayCaster do
  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    let(:object) { described_class.new }

    context "when array of nils" do
      let(:value) { [nil, nil] }

      it { is_expected.to eq(value) }
    end

    context "when array of invalid strings" do
      let(:value) { ["invalid", "1234 not a number"] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of integers" do
      let(:value) { [rand(-10..10), rand(-10..10)] }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when array of floats" do
      let(:value) { [rand(-10.0..10.0), rand(-10.0..10.0)] }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when array of big decimals" do
      let(:value) { [rand(-10.0..10.0).to_d, rand(-10.0..10.0).to_d] }

      it { is_expected.to eq(value) }
    end

    context "when array of integer strings" do
      let(:value) { [rand(-10..10).to_s, rand(-10..10).to_s] }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when array of decimal strings" do
      let(:value) { [rand(-10.0..10.0).to_s, rand(-10.0..10.0).to_s] }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when not an array" do
      let(:value) do
        [
          nil,
          rand(-10..10),
          rand(-10.0..10.0),
          rand(-10.0..10.0).to_d,
          "invalid",
          rand(-10..10).to_s,
          rand(-10.0..10.0).to_s,
        ].sample
      end

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

    context "when array of invalid strings" do
      let(:value) { ["invalid", "1234 not a number"] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of integers" do
      let(:value) { [rand(-10..10), rand(-10..10)] }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when array of floats" do
      let(:value) { [rand(-10.0..10.0), rand(-10.0..10.0)] }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when array of big decimals" do
      let(:value) { [rand(-10.0..10.0).to_d, rand(-10.0..10.0).to_d] }

      it { is_expected.to eq(value) }
    end

    context "when array of integer strings" do
      let(:value) { [rand(-10..10).to_s, rand(-10..10).to_s] }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when array of decimal strings" do
      let(:value) { [rand(-10.0..10.0).to_s, rand(-10.0..10.0).to_s] }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when not an array" do
      let(:value) do
        [
          nil,
          rand(-10..10),
          rand(-10.0..10.0),
          rand(-10.0..10.0).to_d,
          "invalid",
          rand(-10..10).to_s,
          rand(-10.0..10.0).to_s,
        ].sample
      end

      it { is_expected.to eq(value) }
    end
  end
end
