# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::TextCaster do
  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    let(:object) { described_class.new }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when number" do
      let(:value) { rand(0..10) }

      it { is_expected.to eq(value.to_s) }
    end

    context "when string" do
      let(:value) { "test value" }

      it { is_expected.to eq(value) }
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
      let(:value) { rand(0..10) }

      it { is_expected.to eq(value.to_s) }
    end

    context "when string" do
      let(:value) { "test value" }

      it { is_expected.to eq(value) }
    end
  end
end
