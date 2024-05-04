# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::EnumCaster do
  let(:object) { described_class.new }

  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when number" do
      let(:value) { [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d].sample }

      it { is_expected.to eq(value.to_s) }
    end

    context "when date" do
      let(:value) { Date.today + rand(-10..10) }

      it { is_expected.to eq(value.to_s) }
    end

    context "when string" do
      let(:value) { random_string(10) }

      it { is_expected.to eq(value) }
    end

    context "when empty string" do
      let(:value) { "" }

      it { is_expected.to eq(value) }
    end
  end

  describe "#deserialize" do
    subject(:call_method) { object.deserialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when number" do
      let(:value) { [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d].sample }

      it { is_expected.to eq(value.to_s) }
    end

    context "when date" do
      let(:value) { Date.today + rand(-10..10) }

      it { is_expected.to eq(value.to_s) }
    end

    context "when string" do
      let(:value) { random_string(10) }

      it { is_expected.to eq(value) }
    end

    context "when empty string" do
      let(:value) { "" }

      it { is_expected.to eq(value) }
    end
  end
end
