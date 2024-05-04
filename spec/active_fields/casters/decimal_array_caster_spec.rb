# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DecimalArrayCaster do
  let(:object) { described_class.new }

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

    context "when array of invalid strings" do
      let(:value) { ["", "#{rand(-10..10)} not a number #{rand(-10..10)}"] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of numbers" do
      let(:value) { [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d] }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when array of number strings" do
      let(:value) { [rand(-10..10).to_s, rand(-10.0..10.0).to_s] }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when not an array" do
      let(:value) do
        [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d, rand(-10..10).to_s, rand(-10.0..10.0).to_s].sample
      end

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

    context "when array of invalid strings" do
      let(:value) { ["", "#{rand(-10..10)} not a number #{rand(-10..10)}"] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of numbers" do
      let(:value) { [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d] }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when array of number strings" do
      let(:value) { [rand(-10..10).to_s, rand(-10.0..10.0).to_s] }

      it { is_expected.to eq(value.map(&:to_d)) }
    end

    context "when not an array" do
      let(:value) do
        [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d, rand(-10..10).to_s, rand(-10.0..10.0).to_s].sample
      end

      it { is_expected.to be_nil }
    end
  end
end
