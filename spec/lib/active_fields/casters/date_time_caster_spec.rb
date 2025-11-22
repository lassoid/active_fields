# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DateTimeCaster do
  def max_precision = ActiveFields::MAX_DATETIME_PRECISION

  let(:object) { described_class.new(**args) }
  let(:args) { {} }

  describe "#serialize" do
    subject(:call_method) { object.serialize(value) }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
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

    context "with UTC timezone" do
      context "when date" do
        let(:value) { random_date }

        it { is_expected.to eq(value.to_time(:utc).iso8601(max_precision)) }
      end

      context "when date string" do
        let(:value) { random_date.iso8601 }

        it { is_expected.to eq(Date.parse(value).to_time(:utc).iso8601(max_precision)) }
      end

      context "when datetime" do
        let(:value) { random_datetime }

        it { is_expected.to eq(value.utc.iso8601(max_precision)) }
      end

      context "when datetime string" do
        let(:value) { random_datetime.iso8601 }

        it { is_expected.to eq(Time.zone.parse(value).utc.iso8601(max_precision)) }
      end

      context "when datetime string with fractional seconds digits" do
        let(:value) { random_datetime.iso8601(max_precision + 1) }

        it { is_expected.to eq(Time.zone.parse(value).utc.iso8601(max_precision)) }
      end
    end

    context "with non UTC timezone" do
      around do |example|
        Time.use_zone("Moscow") do
          example.run
        end
      end

      context "when date" do
        let(:value) { random_date }

        it { is_expected.to eq(value.to_time(:utc).iso8601(max_precision)) }
      end

      context "when date string" do
        let(:value) { random_date.iso8601 }

        it { is_expected.to eq(Date.parse(value).to_time(:utc).iso8601(max_precision)) }
      end

      context "when datetime" do
        let(:value) { random_datetime }

        it { is_expected.to eq(value.utc.iso8601(max_precision)) }
      end

      context "when datetime string" do
        let(:value) { random_datetime.iso8601 }

        it { is_expected.to eq(Time.zone.parse(value).utc.iso8601(max_precision)) }
      end

      context "when datetime string with fractional seconds digits" do
        let(:value) { random_datetime.iso8601(max_precision + 1) }

        it { is_expected.to eq(Time.zone.parse(value).utc.iso8601(max_precision)) }
      end
    end

    context "with precision" do
      let(:args) { { precision: rand(0..max_precision) } }

      context "when date" do
        let(:value) { random_date }

        it { is_expected.to eq(value.to_time(:utc).iso8601(args[:precision])) }
      end

      context "when date string" do
        let(:value) { random_date.iso8601 }

        it { is_expected.to eq(Date.parse(value).to_time(:utc).iso8601(args[:precision])) }
      end

      context "when datetime" do
        let(:value) { random_datetime }

        it { is_expected.to eq(value.utc.iso8601(args[:precision])) }
      end

      context "when datetime string" do
        let(:value) { random_datetime.iso8601 }

        it { is_expected.to eq(Time.zone.parse(value).utc.iso8601(args[:precision])) }
      end

      context "when datetime string with fractional seconds digits" do
        let(:value) { random_datetime.iso8601(max_precision + 1) }

        it { is_expected.to eq(Time.zone.parse(value).utc.iso8601(args[:precision])) }
      end
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

    context "with UTC timezone" do
      context "when date" do
        let(:value) { random_date }

        it { is_expected.to eq(apply_datetime_precision(value.to_time(:utc).in_time_zone, max_precision)) }
      end

      context "when date string" do
        let(:value) { random_date.iso8601 }

        it { is_expected.to eq(apply_datetime_precision(Date.parse(value).to_time(:utc).in_time_zone, max_precision)) }
      end

      context "when datetime" do
        let(:value) { random_datetime.utc }

        it { is_expected.to eq(apply_datetime_precision(value.in_time_zone, max_precision)) }
      end

      context "when datetime string" do
        let(:value) { random_datetime.utc.iso8601 }

        it { is_expected.to eq(apply_datetime_precision(Time.zone.parse(value).in_time_zone, max_precision)) }
      end

      context "when datetime string with fractional seconds digits" do
        let(:value) { random_datetime.utc.iso8601(max_precision + 1) }

        it { is_expected.to eq(apply_datetime_precision(Time.zone.parse(value).in_time_zone, max_precision)) }
      end
    end

    context "with non UTC timezone" do
      around do |example|
        Time.use_zone("Moscow") do
          example.run
        end
      end

      context "when date" do
        let(:value) { random_date }

        it { is_expected.to eq(apply_datetime_precision(value.to_time(:utc).in_time_zone, max_precision)) }
      end

      context "when date string" do
        let(:value) { random_date.iso8601 }

        it { is_expected.to eq(apply_datetime_precision(Date.parse(value).to_time(:utc).in_time_zone, max_precision)) }
      end

      context "when datetime" do
        let(:value) { random_datetime.utc }

        it { is_expected.to eq(apply_datetime_precision(value.in_time_zone, max_precision)) }
      end

      context "when datetime string" do
        let(:value) { random_datetime.utc.iso8601 }

        it { is_expected.to eq(apply_datetime_precision(Time.zone.parse(value).in_time_zone, max_precision)) }
      end

      context "when datetime string with fractional seconds digits" do
        let(:value) { random_datetime.utc.iso8601(max_precision + 1) }

        it { is_expected.to eq(apply_datetime_precision(Time.zone.parse(value).in_time_zone, max_precision)) }
      end
    end

    context "with precision" do
      let(:args) { { precision: rand(0..max_precision) } }

      context "when date" do
        let(:value) { random_date }

        it { is_expected.to eq(apply_datetime_precision(value.to_time(:utc).in_time_zone, args[:precision])) }
      end

      context "when date string" do
        let(:value) { random_date.iso8601 }

        it do
          expect(call_method).to eq(
            apply_datetime_precision(Date.parse(value).to_time(:utc).in_time_zone, args[:precision]),
          )
        end
      end

      context "when datetime" do
        let(:value) { random_datetime.utc }

        it { is_expected.to eq(apply_datetime_precision(value.in_time_zone, args[:precision])) }
      end

      context "when datetime string" do
        let(:value) { random_datetime.utc.iso8601 }

        it { is_expected.to eq(apply_datetime_precision(Time.zone.parse(value).in_time_zone, args[:precision])) }
      end

      context "when datetime string with fractional seconds digits" do
        let(:value) { random_datetime.utc.iso8601(max_precision + 1) }

        it { is_expected.to eq(apply_datetime_precision(Time.zone.parse(value).in_time_zone, args[:precision])) }
      end
    end
  end
end
