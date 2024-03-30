# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DateArrayCaster do
  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    let(:object) { described_class.new }

    context "when array of nils" do
      let(:value) { [nil, nil] }

      it { is_expected.to eq(value) }
    end

    context "when array of numbers" do
      let(:value) { [rand(0..10), rand(0.0..10.0)] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of invalid strings" do
      let(:value) { ["invalid", "1234 not a date"] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of valid strings" do
      let(:value) { [Date.yesterday.iso8601, Date.tomorrow.iso8601] }

      it { is_expected.to eq(value.map { Date.parse(_1) }) }
    end

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to eq(value) }
    end

    context "when number" do
      let(:value) { [rand(0..10), rand(0.0..10.0)].sample }

      it { is_expected.to eq(value) }
    end

    context "when invalid string" do
      let(:value) { "invalid" }

      it { is_expected.to eq(value) }
    end

    context "when date string" do
      let(:value) { Date.yesterday.iso8601 }

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
      let(:value) { [rand(0..10), rand(0.0..10.0)] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of invalid strings" do
      let(:value) { ["invalid", "1234 not a date"] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of valid strings" do
      let(:value) { [Date.yesterday.iso8601, Date.tomorrow.iso8601] }

      it { is_expected.to eq(value.map { Date.parse(_1) }) }
    end

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to eq(value) }
    end

    context "when number" do
      let(:value) { [rand(0..10), rand(0.0..10.0)].sample }

      it { is_expected.to eq(value) }
    end

    context "when invalid string" do
      let(:value) { "invalid" }

      it { is_expected.to eq(value) }
    end

    context "when date string" do
      let(:value) { Date.yesterday.iso8601 }

      it { is_expected.to eq(value) }
    end
  end
end
