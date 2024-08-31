# frozen_string_literal: true

RSpec.describe ActiveFields::Casters::DateTimeArrayCaster do
  max_precision = RUBY_VERSION >= "3.2" ? 9 : 6 # AR max precision is 6 for old Rubies
  default_precision = 6

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
      let(:value) { ["", "not a datetime"] }

      it { is_expected.to eq(Array.new(value.size, nil)) }
    end

    context "when array of numbers" do
      let(:value) { random_numbers }

      it { is_expected.to eq(Array.new(value.size, nil)) }
    end

    context "when not an array" do
      let(:value) { [random_datetime, random_datetime.iso8601, random_datetime.iso8601(max_precision)].sample }

      it { is_expected.to be_nil }
    end

    context "with UTC timezone" do
      context "when array of dates" do
        let(:value) { [random_date, random_date] }

        it { is_expected.to eq(value.map { _1.to_time(:utc).iso8601(default_precision) }) }
      end

      context "when array of date strings" do
        let(:value) { [random_date.iso8601, random_date.iso8601] }

        it { is_expected.to eq(value.map { Date.parse(_1).to_time(:utc).iso8601(default_precision) }) }
      end

      context "when array of datetimes" do
        let(:value) { [random_datetime, random_datetime] }

        it { is_expected.to eq(value.map { _1.utc.iso8601(default_precision) }) }
      end

      context "when array of datetime strings" do
        let(:value) { [random_datetime.iso8601, random_datetime.iso8601(max_precision)] }

        it { is_expected.to eq(value.map { Time.zone.parse(_1).utc.iso8601(default_precision) }) }
      end
    end

    context "with non UTC timezone" do
      around do |example|
        Time.use_zone("Moscow") do
          example.run
        end
      end

      context "when array of dates" do
        let(:value) { [random_date, random_date] }

        it { is_expected.to eq(value.map { _1.to_time(:utc).iso8601(default_precision) }) }
      end

      context "when array of date strings" do
        let(:value) { [random_date.iso8601, random_date.iso8601] }

        it { is_expected.to eq(value.map { Date.parse(_1).to_time(:utc).iso8601(default_precision) }) }
      end

      context "when array of datetimes" do
        let(:value) { [random_datetime, random_datetime] }

        it { is_expected.to eq(value.map { _1.utc.iso8601(default_precision) }) }
      end

      context "when array of datetime strings" do
        let(:value) { [random_datetime.iso8601, random_datetime.iso8601(max_precision)] }

        it { is_expected.to eq(value.map { Time.zone.parse(_1).utc.iso8601(default_precision) }) }
      end
    end

    context "with precision" do
      let(:args) { { precision: rand(0..max_precision) } }

      context "when array of dates" do
        let(:value) { [random_date, random_date] }

        it { is_expected.to eq(value.map { _1.to_time(:utc).iso8601(args[:precision]) }) }
      end

      context "when array of date strings" do
        let(:value) { [random_date.iso8601, random_date.iso8601] }

        it { is_expected.to eq(value.map { Date.parse(_1).to_time(:utc).iso8601(args[:precision]) }) }
      end

      context "when array of datetimes" do
        let(:value) { [random_datetime, random_datetime] }

        it { is_expected.to eq(value.map { _1.utc.iso8601(args[:precision]) }) }
      end

      context "when array of datetime strings" do
        let(:value) { [random_datetime.iso8601, random_datetime.iso8601(max_precision)] }

        it { is_expected.to eq(value.map { Time.zone.parse(_1).utc.iso8601(args[:precision]) }) }
      end
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

    context "when not an array" do
      let(:value) { [random_datetime, random_datetime.iso8601, random_datetime.iso8601(max_precision)].sample }

      it { is_expected.to be_nil }
    end

    context "with UTC timezone" do
      context "when array of dates" do
        let(:value) { [random_date, random_date] }

        it { is_expected.to eq(value.map { _1.to_time(:utc).in_time_zone }) }
      end

      context "when array of date strings" do
        let(:value) { [random_date.iso8601, random_date.iso8601] }

        it { is_expected.to eq(value.map { Date.parse(_1).to_time(:utc).in_time_zone }) }
      end

      context "when array of datetimes" do
        let(:value) { [random_datetime.utc, random_datetime.utc] }

        it { is_expected.to eq(value.map { apply_datetime_precision(_1.in_time_zone, default_precision) }) }
      end

      context "when array of datetime strings" do
        let(:value) { [random_datetime.utc.iso8601, random_datetime.utc.iso8601(max_precision)] }

        it { is_expected.to eq(value.map { Time.zone.parse(_1).in_time_zone }) } # precision is skipped
      end
    end

    context "with non UTC timezone" do
      around do |example|
        Time.use_zone("Moscow") do
          example.run
        end
      end

      context "when array of dates" do
        let(:value) { [random_date, random_date] }

        it { is_expected.to eq(value.map { _1.to_time(:utc).in_time_zone }) }
      end

      context "when array of date strings" do
        let(:value) { [random_date.iso8601, random_date.iso8601] }

        it { is_expected.to eq(value.map { Date.parse(_1).to_time(:utc).in_time_zone }) }
      end

      context "when array of datetimes" do
        let(:value) { [random_datetime.utc, random_datetime.utc] }

        it { is_expected.to eq(value.map { apply_datetime_precision(_1.in_time_zone, default_precision) }) }
      end

      context "when array of datetime strings" do
        let(:value) { [random_datetime.utc.iso8601, random_datetime.utc.iso8601(max_precision)] }

        it { is_expected.to eq(value.map { Time.zone.parse(_1).in_time_zone }) } # precision is skipped
      end
    end

    context "with precision" do
      let(:args) { { precision: rand(0..max_precision) } }

      context "when array of dates" do
        let(:value) { [random_date, random_date] }

        it { is_expected.to eq(value.map { _1.to_time(:utc).in_time_zone }) }
      end

      context "when array of date strings" do
        let(:value) { [random_date.iso8601, random_date.iso8601] }

        it { is_expected.to eq(value.map { Date.parse(_1).to_time(:utc).in_time_zone }) }
      end

      context "when array of datetimes" do
        let(:value) { [random_datetime.utc, random_datetime.utc] }

        it { is_expected.to eq(value.map { apply_datetime_precision(_1.in_time_zone, args[:precision]) }) }
      end

      context "when array of datetime strings" do
        let(:value) { [random_datetime.utc.iso8601, random_datetime.utc.iso8601(max_precision)] }

        it { is_expected.to eq(value.map { Time.zone.parse(_1).in_time_zone }) } # precision is skipped
      end
    end
  end
end
