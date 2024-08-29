# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DateTimeCaster do
  factory = :datetime_active_field
  max_precision = RUBY_VERSION >= "3.2" ? 9 : 6 # AR max precision is 6 for old Rubies
  default_precision = 6

  let(:object) { described_class.new(active_field) }
  let(:active_field) { build(factory) }

  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context "when date" do
      let(:value) { random_date }

      it { is_expected.to eq(value.beginning_of_day.iso8601(default_precision)) }
    end

    context "when date string" do
      let(:value) { random_date.iso8601 }

      it { is_expected.to eq(Date.parse(value).beginning_of_day.iso8601(default_precision)) }
    end

    context "when datetime" do
      let(:value) { random_datetime }

      it { is_expected.to eq(value.iso8601(default_precision)) }
    end

    context "when datetime string" do
      let(:value) { random_datetime.iso8601 }

      it { is_expected.to eq(Time.zone.parse(value).iso8601(default_precision)) }
    end

    context "when datetime string with fractional seconds digits" do
      let(:value) { random_datetime.iso8601(max_precision) }

      it { is_expected.to eq(Time.zone.parse(value).iso8601(default_precision)) }
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

    context "with precision" do
      before do
        active_field.precision = rand(0..max_precision)
      end

      context "when date" do
        let(:value) { random_date }

        it { is_expected.to eq(value.beginning_of_day.iso8601(active_field.precision)) }
      end

      context "when date string" do
        let(:value) { random_date.iso8601 }

        it { is_expected.to eq(Date.parse(value).beginning_of_day.iso8601(active_field.precision)) }
      end

      context "when datetime" do
        let(:value) { random_datetime }

        it { is_expected.to eq(value.iso8601(active_field.precision)) }
      end

      context "when datetime string" do
        let(:value) { random_datetime.iso8601 }

        it { is_expected.to eq(Time.zone.parse(value).iso8601(active_field.precision)) }
      end

      context "when datetime string with fractional seconds digits" do
        let(:value) { random_datetime.iso8601(max_precision) }

        it { is_expected.to eq(Time.zone.parse(value).iso8601(active_field.precision)) }
      end
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

      it { is_expected.to eq(apply_datetime_precision(value.beginning_of_day, default_precision)) }
    end

    context "when date string" do
      let(:value) { random_date.iso8601 }

      it { is_expected.to eq(apply_datetime_precision(Date.parse(value).beginning_of_day, default_precision)) }
    end

    context "when datetime" do
      let(:value) { random_datetime }

      it { is_expected.to eq(apply_datetime_precision(value, default_precision)) }
    end

    context "when datetime string" do
      let(:value) { random_datetime.iso8601 }

      it { is_expected.to eq(Time.zone.parse(value)) } # precision is skipped
    end

    context "when datetime string with fractional seconds digits" do
      let(:value) { random_datetime.iso8601(max_precision) }

      it { is_expected.to eq(Time.zone.parse(value)) } # precision is skipped
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

    context "with precision" do
      before do
        active_field.precision = rand(0..max_precision)
      end

      context "when date" do
        let(:value) { random_date }

        it { is_expected.to eq(apply_datetime_precision(value.beginning_of_day, active_field.precision)) }
      end

      context "when date string" do
        let(:value) { random_date.iso8601 }

        it { is_expected.to eq(apply_datetime_precision(Date.parse(value).beginning_of_day, active_field.precision)) }
      end

      context "when datetime" do
        let(:value) { random_datetime }

        it { is_expected.to eq(apply_datetime_precision(value, active_field.precision)) }
      end

      context "when datetime string" do
        let(:value) { random_datetime.iso8601 }

        it { is_expected.to eq(Time.zone.parse(value)) } # precision is skipped
      end

      context "when datetime string with fractional seconds digits" do
        let(:value) { random_datetime.iso8601(max_precision) }

        it { is_expected.to eq(Time.zone.parse(value)) } # precision is skipped
      end
    end
  end
end
