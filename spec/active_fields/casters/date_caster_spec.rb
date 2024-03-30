# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DateCaster do
  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    let(:object) { described_class.new }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when number" do
      let(:value) { [rand(0..10), rand(0.0..10.0)].sample }

      it { is_expected.to be_nil }
    end

    context "when invalid string" do
      let(:value) { "invalid" }

      it { is_expected.to be_nil }
    end

    context "when date string" do
      let(:value) { Date.yesterday.iso8601 }

      it { is_expected.to eq(Date.parse(value)) }
    end
  end

  describe "#deserialize" do
    subject(:call_method) { object.deserialize(value) }

    let(:object) { described_class.new }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when number" do
      let(:value) { [rand(0..10), rand(0.0..10.0)].sample }

      it { is_expected.to be_nil }
    end

    context "when invalid string" do
      let(:value) { "invalid" }

      it { is_expected.to be_nil }
    end

    context "when date string" do
      let(:value) { Date.yesterday.iso8601 }

      it { is_expected.to eq(Date.parse(value)) }
    end
  end
end
