# frozen_string_literal: true

RSpec.shared_examples "store_attribute_datetime" do |attr_name, store_attr_name, klass|
  max_precision = RUBY_VERSION >= "3.2" ? 9 : 6 # AR max precision is 6 for old Rubies
  default_precision = 6

  describe "##{attr_name}" do
    subject(:call_method) { record.public_send(attr_name) }

    let(:record) { klass.new }

    before do
      record.public_send(store_attr_name)[attr_name.to_s] = internal_value
    end

    context "when internal value is nil" do
      let(:internal_value) { nil }

      it { is_expected.to be_nil }
    end

    context "when internal value is a number" do
      let(:internal_value) { random_number }

      it { is_expected.to be_nil }
    end

    context "when internal value is an invalid string" do
      let(:internal_value) { "not a datetime" }

      it { is_expected.to be_nil }
    end

    context "when internal value is an empty string" do
      let(:internal_value) { "" }

      it { is_expected.to be_nil }
    end

    context "with UTC timezone" do
      context "when internal value is a date" do
        let(:internal_value) { random_date }

        it { is_expected.to eq(internal_value.to_time(:utc).in_time_zone) }
      end

      context "when internal value is a date string" do
        let(:internal_value) { random_date.iso8601 }

        it { is_expected.to eq(Date.parse(internal_value).to_time(:utc).in_time_zone) }
      end

      context "when internal value is a datetime" do
        let(:internal_value) { random_datetime.utc }

        it { is_expected.to eq(apply_datetime_precision(internal_value.in_time_zone, default_precision)) }
      end

      context "when internal value is a datetime string" do
        let(:internal_value) { random_datetime.utc.iso8601 }

        it { is_expected.to eq(Time.zone.parse(internal_value).in_time_zone) } # precision is skipped
      end

      context "when internal value is a datetime string with fractional seconds digits" do
        let(:internal_value) { random_datetime.utc.iso8601(max_precision) }

        it { is_expected.to eq(Time.zone.parse(internal_value).in_time_zone) } # precision is skipped
      end
    end

    context "with non UTC timezone" do
      around do |example|
        Time.use_zone("Moscow") do
          example.run
        end
      end

      context "when internal value is a date" do
        let(:internal_value) { random_date }

        it { is_expected.to eq(internal_value.to_time(:utc).in_time_zone) }
      end

      context "when internal value is a date string" do
        let(:internal_value) { random_date.iso8601 }

        it { is_expected.to eq(Date.parse(internal_value).to_time(:utc).in_time_zone) }
      end

      context "when internal value is a datetime" do
        let(:internal_value) { random_datetime.utc }

        it { is_expected.to eq(apply_datetime_precision(internal_value.in_time_zone, default_precision)) }
      end

      context "when internal value is a datetime string" do
        let(:internal_value) { random_datetime.utc.iso8601 }

        it { is_expected.to eq(Time.zone.parse(internal_value).in_time_zone) } # precision is skipped
      end

      context "when internal value is a datetime string with fractional seconds digits" do
        let(:internal_value) { random_datetime.utc.iso8601(max_precision) }

        it { is_expected.to eq(Time.zone.parse(internal_value).in_time_zone) } # precision is skipped
      end
    end
  end

  describe "##{attr_name}=" do
    subject(:call_method) { record.public_send(:"#{attr_name}=", value) }

    let(:record) { klass.new }

    context "when value is nil" do
      let(:value) { nil }

      it "sets nil" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to be_nil
      end
    end

    context "when value is a number" do
      let(:value) { random_number }

      it "sets nil" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to be_nil
      end
    end

    context "when value is an invalid string" do
      let(:value) { "not a datetime" }

      it "sets nil" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to be_nil
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "sets nil" do
        call_method

        expect(record.public_send(store_attr_name)[attr_name.to_s]).to be_nil
      end
    end

    context "with UTC timezone" do
      context "when value is a date" do
        let(:value) { random_date }

        it "sets datetime as string" do
          call_method

          expect(record.public_send(store_attr_name)[attr_name.to_s])
            .to eq(value.to_time(:utc).iso8601(default_precision))
        end
      end

      context "when value is a date string" do
        let(:value) { random_date.iso8601 }

        it "sets datetime as string" do
          call_method

          expect(record.public_send(store_attr_name)[attr_name.to_s])
            .to eq(Date.parse(value).to_time(:utc).iso8601(default_precision))
        end
      end

      context "when value is a datetime" do
        let(:value) { random_datetime }

        it "sets datetime as string" do
          call_method

          expect(record.public_send(store_attr_name)[attr_name.to_s])
            .to eq(value.utc.iso8601(default_precision))
        end
      end

      context "when value is a datetime string" do
        let(:value) { random_datetime.iso8601 }

        it "sets datetime as string" do
          call_method

          expect(record.public_send(store_attr_name)[attr_name.to_s])
            .to eq(Time.zone.parse(value).utc.iso8601(default_precision))
        end
      end

      context "when value is a datetime string with fractional seconds digits" do
        let(:value) { random_datetime.iso8601(max_precision) }

        it "sets datetime as string" do
          call_method

          expect(record.public_send(store_attr_name)[attr_name.to_s])
            .to eq(Time.zone.parse(value).utc.iso8601(default_precision))
        end
      end
    end

    context "with non UTC timezone" do
      around do |example|
        Time.use_zone("Moscow") do
          example.run
        end
      end

      context "when value is a date" do
        let(:value) { random_date }

        it "sets datetime as string" do
          call_method

          expect(record.public_send(store_attr_name)[attr_name.to_s])
            .to eq(value.to_time(:utc).iso8601(default_precision))
        end
      end

      context "when value is a date string" do
        let(:value) { random_date.iso8601 }

        it "sets datetime as string" do
          call_method

          expect(record.public_send(store_attr_name)[attr_name.to_s])
            .to eq(Date.parse(value).to_time(:utc).iso8601(default_precision))
        end
      end

      context "when value is a datetime" do
        let(:value) { random_datetime }

        it "sets datetime as string" do
          call_method

          expect(record.public_send(store_attr_name)[attr_name.to_s])
            .to eq(value.utc.iso8601(default_precision))
        end
      end

      context "when value is a datetime string" do
        let(:value) { random_datetime.iso8601 }

        it "sets datetime as string" do
          call_method

          expect(record.public_send(store_attr_name)[attr_name.to_s])
            .to eq(Time.zone.parse(value).utc.iso8601(default_precision))
        end
      end

      context "when value is a datetime string with fractional seconds digits" do
        let(:value) { random_datetime.iso8601(max_precision) }

        it "sets datetime as string" do
          call_method

          expect(record.public_send(store_attr_name)[attr_name.to_s])
            .to eq(Time.zone.parse(value).utc.iso8601(default_precision))
        end
      end
    end
  end
end
