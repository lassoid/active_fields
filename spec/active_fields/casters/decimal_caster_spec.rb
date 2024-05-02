# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DecimalCaster do
  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    let(:object) { described_class.new }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when integer" do
      let(:value) { rand(0..10) }

      it { is_expected.to eq(BigDecimal(value)) }
    end

    context "when decimal" do
      let(:value) { rand(0.0..10.0) }

      it { is_expected.to eq(value) }
    end

    context "when string with integer" do
      let(:value) { rand(0..10).to_s }

      it { is_expected.to eq(BigDecimal(value)) }
    end

    context "when string with decimal" do
      let(:value) { rand(0.0..10.0).to_s }

      it { is_expected.to eq(BigDecimal(value)) }
    end

    context "when string" do
      let(:value) { "test value" }

      it { is_expected.to be_nil }
    end
  end

  describe "#deserialize" do
    subject(:call_method) { object.deserialize(value) }

    let(:object) { described_class.new }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when integer" do
      let(:value) { rand(0..10) }

      it { is_expected.to eq(BigDecimal(value)) }
    end

    context "when decimal" do
      let(:value) { rand(0.0..10.0) }

      it { is_expected.to eq(value) }
    end

    context "when string with integer" do
      let(:value) { rand(0..10).to_s }

      it { is_expected.to eq(BigDecimal(value)) }
    end

    context "when string with decimal" do
      let(:value) { rand(0.0..10.0).to_s }

      it { is_expected.to eq(BigDecimal(value)) }
    end

    context "when string" do
      let(:value) { "test value" }

      it { is_expected.to be_nil }
    end
  end
end
