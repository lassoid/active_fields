# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DateTimeCaster do
  factory = :datetime_active_field
  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when datetime" do
      let(:value) { random_datetime }

      it { is_expected.to eq(value.iso8601) }
    end

    context "when datetime string" do
      let(:value) { random_datetime.iso8601 }

      it { is_expected.to eq(value) }
    end

    context "when number" do
      let(:value) { random_number }

      it { is_expected.to be_nil }
    end

    context "when invalid string" do
      let(:value) { "not a datetime" }

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

    context "when datetime" do
      let(:value) { random_datetime }

      it { is_expected.to eq(value) }
    end

    context "when datetime string" do
      let(:value) { random_datetime.iso8601 }

      it { is_expected.to eq(Time.zone.parse(value)) }
    end

    context "when number" do
      let(:value) { random_number }

      it { is_expected.to be_nil }
    end

    context "when invalid string" do
      let(:value) { "not a datetime" }

      it { is_expected.to be_nil }
    end

    context "when empty string" do
      let(:value) { "" }

      it { is_expected.to be_nil }
    end
  end
end
