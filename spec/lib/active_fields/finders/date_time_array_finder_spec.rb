# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ActiveFields::Finders::DateTimeArrayFinder do
  it_behaves_like "field_finder"

  describe "#search" do
    subject(:perform_search) do
      described_class.new(active_field: active_field).search(op: op, value: value)
    end

    def max_precision = ActiveFields::MAX_DATETIME_PRECISION

    let!(:active_field) { create(:datetime_array_active_field, precision: precision) }
    let(:precision) { nil }
    let(:saved_value) { random_datetime } # precision is greater than maximum allowed

    let!(:records) do
      calculated_precision = precision || max_precision
      minimum_delta = 10**-calculated_precision

      [
        [saved_value],
        [saved_value - minimum_delta],
        [saved_value + minimum_delta],

        [rand(1..10).hours.before(saved_value)],
        [rand(1..10).hours.after(saved_value)],

        [saved_value - minimum_delta, saved_value],
        [saved_value, saved_value + minimum_delta],

        [rand(1..10).hours.before(saved_value), saved_value],
        [saved_value, rand(1..10).hours.after(saved_value)],

        [rand(1..10).hours.before(saved_value), rand(1..10).hours.after(saved_value)],
        [],
      ].map do |value|
        create(active_value_factory, active_field: active_field, value: value)
      end
    end

    context "without precision" do
      context "with include op" do
        let(:op) { ["|=", :"|=", "include", :include].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns only records that contain the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.include?(casted_value) })
              .and exclude(*records.reject { |r| r.value.include?(casted_value) })
          end
        end

        context "when value is nil" do
          let(:value) { nil }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with not_include op" do
        let(:op) { ["!|=", :"!|=", "not_include", :not_include].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns only records that doesn't contain the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.reject { |r| r.value.include?(casted_value) })
              .and exclude(*records.select { |r| r.value.include?(casted_value) })
          end
        end

        context "when value is nil" do
          let(:value) { nil }

          it "returns all records" do
            expect(perform_search).to include(*records)
          end
        end
      end

      context "with any_gt op" do
        let(:op) { ["|>", :"|>", "any_gt", :any_gt].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns only records that contain an element greater than the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? { |elem| elem > casted_value } })
              .and exclude(*records.reject { |r| r.value.any? { |elem| elem > casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { nil }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with any_gteq op" do
        let(:op) { ["|>=", :"|>=", "any_gteq", :any_gteq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns only records that contain an element greater than or equal to the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? { |elem| elem >= casted_value } })
              .and exclude(*records.reject { |r| r.value.any? { |elem| elem >= casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { nil }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with any_lt op" do
        let(:op) { ["|<", :"|<", "any_lt", :any_lt].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns only records that contain an element less than the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? { |elem| elem < casted_value } })
              .and exclude(*records.reject { |r| r.value.any? { |elem| elem < casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { nil }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with any_lteq op" do
        let(:op) { ["|<=", :"|<=", "any_lteq", :any_lteq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns only records that contain an element less than or equal to the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? { |elem| elem <= casted_value } })
              .and exclude(*records.reject { |r| r.value.any? { |elem| elem <= casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { nil }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with all_gt op" do
        let(:op) { ["&>", :"&>", "all_gt", :all_gt].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns only records where all elements are greater than the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? && r.value.all? { |elem| elem > casted_value } })
              .and exclude(*records.reject { |r| r.value.any? && r.value.all? { |elem| elem > casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with all_gteq op" do
        let(:op) { ["&>=", :"&>=", "all_gteq", :all_gteq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns only records where all elements are greater than or equal to the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? && r.value.all? { |elem| elem >= casted_value } })
              .and exclude(*records.reject { |r| r.value.any? && r.value.all? { |elem| elem >= casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with all_lt op" do
        let(:op) { ["&<", :"&<", "all_lt", :all_lt].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns only records where all elements are less than the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? && r.value.all? { |elem| elem < casted_value } })
              .and exclude(*records.reject { |r| r.value.any? && r.value.all? { |elem| elem < casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with all_lteq op" do
        let(:op) { ["&<=", :"&<=", "all_lteq", :all_lteq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(max_precision + 1)].sample }

          it "returns only records where all elements are less than or equal to the value" do
            casted_value = apply_datetime_precision(saved_value, max_precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? && r.value.all? { |elem| elem <= casted_value } })
              .and exclude(*records.reject { |r| r.value.any? && r.value.all? { |elem| elem <= casted_value } })
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

      context "with include op" do
        let(:op) { ["|=", :"|=", "include", :include].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(precision + 1)].sample }

          it "returns only records that contain the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.include?(casted_value) })
              .and exclude(*records.reject { |r| r.value.include?(casted_value) })
          end
        end

        context "when value is nil" do
          let(:value) { nil }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with not_include op" do
        let(:op) { ["!|=", :"!|=", "not_include", :not_include].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(precision + 1)].sample }

          it "returns only records that doesn't contain the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.reject { |r| r.value.include?(casted_value) })
              .and exclude(*records.select { |r| r.value.include?(casted_value) })
          end
        end

        context "when value is nil" do
          let(:value) { nil }

          it "returns all records" do
            expect(perform_search).to include(*records)
          end
        end
      end

      context "with any_gt op" do
        let(:op) { ["|>", :"|>", "any_gt", :any_gt].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(precision + 1)].sample }

          it "returns only records that contain an element greater than the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? { |elem| elem > casted_value } })
              .and exclude(*records.reject { |r| r.value.any? { |elem| elem > casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { nil }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with any_gteq op" do
        let(:op) { ["|>=", :"|>=", "any_gteq", :any_gteq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(precision + 1)].sample }

          it "returns only records that contain an element greater than or equal to the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? { |elem| elem >= casted_value } })
              .and exclude(*records.reject { |r| r.value.any? { |elem| elem >= casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { nil }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with any_lt op" do
        let(:op) { ["|<", :"|<", "any_lt", :any_lt].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(precision + 1)].sample }

          it "returns only records that contain an element less than the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? { |elem| elem < casted_value } })
              .and exclude(*records.reject { |r| r.value.any? { |elem| elem < casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { nil }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with any_lteq op" do
        let(:op) { ["|<=", :"|<=", "any_lteq", :any_lteq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(precision + 1)].sample }

          it "returns only records that contain an element less than or equal to the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? { |elem| elem <= casted_value } })
              .and exclude(*records.reject { |r| r.value.any? { |elem| elem <= casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { nil }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with all_gt op" do
        let(:op) { ["&>", :"&>", "all_gt", :all_gt].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(precision + 1)].sample }

          it "returns only records where all elements are greater than the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? && r.value.all? { |elem| elem > casted_value } })
              .and exclude(*records.reject { |r| r.value.any? && r.value.all? { |elem| elem > casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with all_gteq op" do
        let(:op) { ["&>=", :"&>=", "all_gteq", :all_gteq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(precision + 1)].sample }

          it "returns only records where all elements are greater than or equal to the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? && r.value.all? { |elem| elem >= casted_value } })
              .and exclude(*records.reject { |r| r.value.any? && r.value.all? { |elem| elem >= casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with all_lt op" do
        let(:op) { ["&<", :"&<", "all_lt", :all_lt].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(precision + 1)].sample }

          it "returns only records where all elements are less than the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? && r.value.all? { |elem| elem < casted_value } })
              .and exclude(*records.reject { |r| r.value.any? && r.value.all? { |elem| elem < casted_value } })
          end
        end

        context "when value is nil" do
          let(:value) { [nil, ""].sample }

          it "returns no records" do
            expect(perform_search).to exclude(*records)
          end
        end
      end

      context "with all_lteq op" do
        let(:op) { ["&<=", :"&<=", "all_lteq", :all_lteq].sample }

        context "when value is a datetime" do
          let(:value) { [saved_value, saved_value.iso8601(precision + 1)].sample }

          it "returns only records where all elements are less than or equal to the value" do
            casted_value = apply_datetime_precision(saved_value, precision)

            expect(perform_search)
              .to include(*records.select { |r| r.value.any? && r.value.all? { |elem| elem <= casted_value } })
              .and exclude(*records.reject { |r| r.value.any? && r.value.all? { |elem| elem <= casted_value } })
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

    it_behaves_like "finder_array_size"

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
