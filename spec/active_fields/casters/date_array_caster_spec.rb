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
      let(:value) { [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d] }

      it { is_expected.to eq([nil, nil, nil]) }
    end

    context "when array of invalid strings" do
      let(:value) { ["invalid", "1234 not a date"] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of dates" do
      let(:value) { [Date.today + rand(-10..10), Date.today + rand(-10..10)] }

      it { is_expected.to eq(value.map(&:iso8601)) }
    end

    context "when array of date strings" do
      let(:value) { [(Date.today + rand(-10..10)).iso8601, (Date.today + rand(-10..10)).iso8601] }

      it { is_expected.to eq(value) }
    end

    context "when not an array" do
      let(:value) do
        [nil, rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d, "invalid", Date.today.iso8601, Date.today]
          .sample
      end

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
      let(:value) { [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d] }

      it { is_expected.to eq([nil, nil, nil]) }
    end

    context "when array of invalid strings" do
      let(:value) { ["invalid", "1234 not a date"] }

      it { is_expected.to eq([nil, nil]) }
    end

    context "when array of dates" do
      let(:value) { [Date.today + rand(-10..10), Date.today + rand(-10..10)] }

      it { is_expected.to eq(value) }
    end

    context "when array of date strings" do
      let(:value) { [Date.yesterday.iso8601, Date.tomorrow.iso8601] }

      it { is_expected.to eq(value.map { Date.parse(_1) }) }
    end

    context "when not an array" do
      let(:value) do
        [nil, rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d, "invalid", Date.today.iso8601, Date.today]
          .sample
      end

      it { is_expected.to eq(value) }
    end
  end
end
