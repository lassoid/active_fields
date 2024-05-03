# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DateCaster do
  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    let(:object) { described_class.new }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when number" do
      let(:value) { [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d].sample }

      it { is_expected.to be_nil }
    end

    context "when invalid string" do
      let(:value) { ["invalid", "1234 not a date"].sample }

      it { is_expected.to be_nil }
    end

    context "when date" do
      let(:value) { Date.today + rand(-10..10) }

      it { is_expected.to eq(value.iso8601) }
    end

    context "when date string" do
      let(:value) { (Date.today + rand(-10..10)).iso8601 }

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
      let(:value) { [rand(-10..10), rand(-10.0..10.0), rand(-10.0..10.0).to_d].sample }

      it { is_expected.to be_nil }
    end

    context "when invalid string" do
      let(:value) { ["invalid", "1234 not a date"].sample }

      it { is_expected.to be_nil }
    end

    context "when date" do
      let(:value) { Date.today + rand(-10..10) }

      it { is_expected.to eq(value) }
    end

    context "when date string" do
      let(:value) { (Date.today + rand(-10..10)).iso8601 }

      it { is_expected.to eq(Date.parse(value)) }
    end
  end
end
