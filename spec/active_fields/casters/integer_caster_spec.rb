# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::IntegerCaster do
  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    let(:object) { described_class.new }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when invalid string" do
      let(:value) { "1234 not a number" }

      it { is_expected.to be_nil }
    end

    context "when integer" do
      let(:value) { rand(-10..10) }

      it { is_expected.to eq(value) }
    end

    context "when float" do
      let(:value) { rand(-10.0..10.0) }

      it { is_expected.to eq(value.to_i) }
    end

    context "when big decimal" do
      let(:value) { rand(-10.0..10.0).to_d }

      it { is_expected.to eq(value.to_i) }
    end

    context "when integer string" do
      let(:value) { rand(-10..10).to_s }

      it { is_expected.to eq(value.to_i) }
    end

    context "when decimal string" do
      let(:value) { rand(-10.0..10.0).to_s }

      it { is_expected.to eq(value.to_i) }
    end
  end

  describe "#deserialize" do
    subject(:call_method) { object.deserialize(value) }

    let(:object) { described_class.new }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when invalid string" do
      let(:value) { "1234 not a number" }

      it { is_expected.to be_nil }
    end

    context "when integer" do
      let(:value) { rand(-10..10) }

      it { is_expected.to eq(value) }
    end

    context "when float" do
      let(:value) { rand(-10.0..10.0) }

      it { is_expected.to eq(value.to_i) }
    end

    context "when big decimal" do
      let(:value) { rand(-10.0..10.0).to_d }

      it { is_expected.to eq(value.to_i) }
    end

    context "when integer string" do
      let(:value) { rand(-10..10).to_s }

      it { is_expected.to eq(value.to_i) }
    end

    context "when decimal string" do
      let(:value) { rand(-10.0..10.0).to_s }

      it { is_expected.to eq(value.to_i) }
    end
  end
end
