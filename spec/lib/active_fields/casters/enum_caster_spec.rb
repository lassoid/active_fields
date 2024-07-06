# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::EnumCaster do
  factory = :enum_active_field
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when number" do
      let(:value) { random_number }

      it { is_expected.to eq(value.to_s) }
    end

    context "when date" do
      let(:value) { random_date }

      it { is_expected.to eq(value.to_s) }
    end

    context "when string" do
      let(:value) { random_string }

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
      let(:value) { random_number }

      it { is_expected.to eq(value.to_s) }
    end

    context "when date" do
      let(:value) { random_date }

      it { is_expected.to eq(value.to_s) }
    end

    context "when string" do
      let(:value) { random_string }

      it { is_expected.to eq(value) }
    end

    context "when empty string" do
      let(:value) { "" }

      it { is_expected.to eq(value) }
    end
  end
end
