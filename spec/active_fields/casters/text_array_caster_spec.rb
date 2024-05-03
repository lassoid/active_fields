# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::TextArrayCaster do
  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    let(:object) { described_class.new }

    context "when array of nils" do
      let(:value) { [nil, nil] }

      it { is_expected.to eq(value) }
    end

    context "when array of numbers" do
      let(:value) { [rand(-10..10), rand(-10..10)] }

      it { is_expected.to eq(value.map(&:to_s)) }
    end

    context "when array of strings" do
      let(:value) { %w[first second] }

      it { is_expected.to eq(value) }
    end

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to eq(value) }
    end

    context "when not an array" do
      let(:value) { [rand(-10..10), "test value", Date.today].sample }

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

    context "when array of numbers" do
      let(:value) { [rand(-10..10), rand(-10..10)] }

      it { is_expected.to eq(value.map(&:to_s)) }
    end

    context "when array of strings" do
      let(:value) { %w[first second] }

      it { is_expected.to eq(value) }
    end

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to eq(value) }
    end

    context "when not an array" do
      let(:value) { [rand(-10..10), "test value", Date.today].sample }

      it { is_expected.to eq(value) }
    end
  end
end
