# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DateCaster do
  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when date" do
      let(:value) { random_date }

      it { is_expected.to eq(value.iso8601) }
    end

    context "when date string" do
      let(:value) { random_date.iso8601 }

      it { is_expected.to eq(value) }
    end

    context "when number" do
      let(:value) { random_number }

      it { is_expected.to be_nil }
    end

    context "when invalid string" do
      let(:value) { "not a date" }

      it { is_expected.to be_nil }
    end

    context "when empty string" do
      let(:value) { "" }

      it { is_expected.to be_nil }
    end
  end

  describe "#deserialize" do
    subject(:call_method) { object.deserialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when date" do
      let(:value) { random_date }

      it { is_expected.to eq(value) }
    end

    context "when date string" do
      let(:value) { random_date.iso8601 }

      it { is_expected.to eq(Date.parse(value)) }
    end

    context "when number" do
      let(:value) { random_number }

      it { is_expected.to be_nil }
    end

    context "when invalid string" do
      let(:value) { "not a date" }

      it { is_expected.to be_nil }
    end

    context "when empty string" do
      let(:value) { "" }

      it { is_expected.to be_nil }
    end
  end
end
