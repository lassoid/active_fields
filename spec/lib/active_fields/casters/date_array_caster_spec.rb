# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DateArrayCaster do
  let(:object) { described_class.new(**args) }
  let(:args) { {} }

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
      let(:value) { ["", "not a date"] }

      it { is_expected.to eq(Array.new(value.size, nil)) }
    end

    context "when array of numbers" do
      let(:value) { random_numbers }

      it { is_expected.to eq(Array.new(value.size, nil)) }
    end

    context "when array of dates" do
      let(:value) { [random_date, random_date] }

      it { is_expected.to eq(value.map(&:iso8601)) }
    end

    context "when array of date strings" do
      let(:value) { [random_date.iso8601, random_date.iso8601] }

      it { is_expected.to eq(value) }
    end

    context "when not an array" do
      let(:value) { [random_date, random_date.iso8601].sample }

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
      let(:value) { ["", "not a date"] }

      it { is_expected.to eq(Array.new(value.size, nil)) }
    end

    context "when array of numbers" do
      let(:value) { random_numbers }

      it { is_expected.to eq(Array.new(value.size, nil)) }
    end

    context "when array of dates" do
      let(:value) { [random_date, random_date] }

      it { is_expected.to eq(value) }
    end

    context "when array of date strings" do
      let(:value) { [random_date.iso8601, random_date.iso8601] }

      it { is_expected.to eq(value.map { |el| Date.parse(el) }) }
    end

    context "when not an array" do
      let(:value) { [random_date, random_date.iso8601].sample }

      it { is_expected.to be_nil }
    end
  end
end
