# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ActiveFields::Finders::DateTimeFinder do
  include_examples "field_finder"

  describe "#search" do
    subject(:perform_search) do
      described_class.new(active_field: active_field).search(op: op, value: value)
    end

    max_precision = ActiveFields::MAX_DATETIME_PRECISION

    let!(:active_field) { create(:datetime_active_field, precision: precision) }
    let(:precision) { nil }
    let(:saved_value) { random_datetime } # precision is greater than maximum allowed

    let!(:records) do
      calculated_precision = precision || max_precision
      minimum_delta = 10**-calculated_precision

      [
        saved_value,
        saved_value - minimum_delta,
        saved_value + minimum_delta,
        rand(1..10).hours.before(saved_value),
        rand(1..10).hours.after(saved_value),
        nil,
      ].map do |value|
        create(active_value_factory, active_field: active_field, value: value)
      end
    end

    context "without precision" do
      context "with eq op" do
        let(:op) { ["=", :"=", "eq", :eq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns only records with such value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { _1.value == casted_value })
              .and exclude(*records.reject { _1.value == casted_value })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns only records with null value" do
            expect(perform_search)
              .to include(*records.select { _1.value.nil? })
              .and exclude(*records.reject { _1.value.nil? })
          end
        end
      end

      context "with not_eq op" do
        let(:op) { ["!=", :"!=", "not_eq", :not_eq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns all records except with such value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.reject { _1.value == casted_value })
              .and exclude(*records.select { _1.value == casted_value })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns only records with not null value" do
            expect(perform_search)
              .to include(*records.reject { _1.value.nil? })
              .and exclude(*records.select { _1.value.nil? })
          end
        end
      end

      context "with gt op" do
        let(:op) { [">", :">", "gt", :gt].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns records greater than the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { _1.value && _1.value > casted_value })
              .and exclude(*records.reject { _1.value && _1.value > casted_value })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with gteq op" do
        let(:op) { [">=", :">=", "gteq", :gteq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns records greater than or equal to the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { _1.value && _1.value >= casted_value })
              .and exclude(*records.reject { _1.value && _1.value >= casted_value })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with lt op" do
        let(:op) { ["<", :"<", "lt", :lt].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns records less than the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { _1.value && _1.value < casted_value })
              .and exclude(*records.reject { _1.value && _1.value < casted_value })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with lteq op" do
        let(:op) { ["<=", :"<=", "lteq", :lteq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns records less than or equal to the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { _1.value && _1.value <= casted_value })
              .and exclude(*records.reject { _1.value && _1.value <= casted_value })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end
    end

    context "with precision" do
      let(:precision) { rand(0..max_precision) }

      context "with eq op" do
        let(:op) { ["=", :"=", "eq", :eq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns only records with such value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { _1.value == casted_value })
              .and exclude(*records.reject { _1.value == casted_value })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns only records with null value" do
            expect(perform_search)
              .to include(*records.select { _1.value.nil? })
              .and exclude(*records.reject { _1.value.nil? })
          end
        end
      end

      context "with not_eq op" do
        let(:op) { ["!=", :"!=", "not_eq", :not_eq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns all records except with such value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.reject { _1.value == casted_value })
              .and exclude(*records.select { _1.value == casted_value })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns only records with not null value" do
            expect(perform_search)
              .to include(*records.reject { _1.value.nil? })
              .and exclude(*records.select { _1.value.nil? })
          end
        end
      end

      context "with gt op" do
        let(:op) { [">", :">", "gt", :gt].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns records greater than the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { _1.value && _1.value > casted_value })
              .and exclude(*records.reject { _1.value && _1.value > casted_value })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with gteq op" do
        let(:op) { [">=", :">=", "gteq", :gteq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns records greater than or equal to the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { _1.value && _1.value >= casted_value })
              .and exclude(*records.reject { _1.value && _1.value >= casted_value })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with lt op" do
        let(:op) { ["<", :"<", "lt", :lt].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns records less than the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { _1.value && _1.value < casted_value })
              .and exclude(*records.reject { _1.value && _1.value < casted_value })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with lteq op" do
        let(:op) { ["<=", :"<=", "lteq", :lteq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns records less than or equal to the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { _1.value && _1.value <= casted_value })
              .and exclude(*records.reject { _1.value && _1.value <= casted_value })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end
    end

    context "with not existing or nil op" do
      let(:op) { ["invalid", nil].sample }
      let(:value) { nil }

      it "returns nil" do
        expect(perform_search).to be_nil
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
