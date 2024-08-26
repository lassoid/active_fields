# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DateTimeArrayCaster do
  factory = :datetime_array_active_field
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

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
      let(:value) { ["", "not a datetime"] }

      it { is_expected.to eq(Array.new(value.size, nil)) }
    end

    context "when array of numbers" do
      let(:value) { random_numbers }

      it { is_expected.to eq(Array.new(value.size, nil)) }
    end

    context "when array of datetimes" do
      let(:value) { [random_datetime, random_datetime] }

      it { is_expected.to eq(value.map(&:iso8601)) }
    end

    context "when array of datetime strings" do
      let(:value) { [random_datetime.iso8601, random_datetime.iso8601] }

      it { is_expected.to eq(value) }
    end

    context "when not an array" do
      let(:value) { [random_datetime, random_datetime.iso8601].sample }

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
      let(:value) { ["", "not a datetime"] }

      it { is_expected.to eq(Array.new(value.size, nil)) }
    end

    context "when array of numbers" do
      let(:value) { random_numbers }

      it { is_expected.to eq(Array.new(value.size, nil)) }
    end

    context "when array of datetimes" do
      let(:value) { [random_datetime, random_datetime] }

      it { is_expected.to eq(value) }
    end

    context "when array of datetime strings" do
      let(:value) { [random_datetime.iso8601, random_datetime.iso8601] }

      it { is_expected.to eq(value.map { Time.zone.parse(_1) }) }
    end

    context "when not an array" do
      let(:value) { [random_datetime, random_datetime.iso8601].sample }

      it { is_expected.to be_nil }
    end
  end
end
