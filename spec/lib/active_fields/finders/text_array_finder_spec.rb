# frozen_string_literal: true

RSpec.describe ActiveFields::Finders::TextArrayFinder do
  it_behaves_like "field_finder"

  describe "#search" do
    subject(:perform_search) do
      described_class.new(active_field: active_field).search(op: op, value: value)
    end

    let!(:active_field) { create(:text_array_active_field) }
    let(:saved_value) { random_string }

    let!(:records) do
      [
        [saved_value],
        [random_string],
        [saved_value, random_string],
        [random_string, random_string],
        [""],
        ["", saved_value],
        ["", random_string],
        ["start_#{random_string}"],
        ["", "start_#{random_string}"],
        [],
      ].map do |value|
        create(active_value_factory, active_field: active_field, value: value)
      end
    end

    context "with include op" do
      let(:op) { ["|=", :"|=", "include", :include].sample }

      context "when value is a string" do
        let(:value) { saved_value }

        it "returns only records that contain the value" do
          expect(perform_search)
            .to include(*records.select { it.value.include?(value) })
            .and exclude(*records.reject { it.value.include?(value) })
        end
      end

      context "when value is an empty string" do
        let(:value) { "" }

        it "returns only records that contain the value" do
          expect(perform_search)
            .to include(*records.select { it.value.include?(value) })
            .and exclude(*records.reject { it.value.include?(value) })
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

      context "when value is a string" do
        let(:value) { saved_value }

        it "returns only records that doesn't contain the value" do
          expect(perform_search)
            .to include(*records.reject { it.value.include?(value) })
            .and exclude(*records.select { it.value.include?(value) })
        end
      end

      context "when value is an empty string" do
        let(:value) { "" }

        it "returns only records that doesn't contain the value" do
          expect(perform_search)
            .to include(*records.reject { it.value.include?(value) })
            .and exclude(*records.select { it.value.include?(value) })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns all records" do
          expect(perform_search).to include(*records)
        end
      end
    end

    context "with any_start_with op" do
      let(:op) { ["|^", :"|^", "any_start_with", :any_start_with].sample }

      context "when value is a string" do
        let(:value) { "start_" }

        it "returns only records that contain any element starting with the value" do
          expect(perform_search)
            .to include(*records.select { it.value.any? { |elem| elem.start_with?(value) } })
            .and exclude(*records.reject { it.value.any? { |elem| elem.start_with?(value) } })
        end
      end

      context "when value is an empty string" do
        let(:value) { "" }

        it "returns all non-empty records" do
          expect(perform_search)
            .to include(*records.select { it.value.any? })
            .and exclude(*records.reject { it.value.any? })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
        end
      end
    end

    context "with all_start_with op" do
      let(:op) { ["&^", :"&^", "all_start_with", :all_start_with].sample }

      context "when value is a string" do
        let(:value) { "start_" }

        it "returns only records that elements start with the value" do
          expect(perform_search)
            .to include(*records.select { it.value.any? && it.value.all? { |elem| elem.start_with?(value) } })
            .and exclude(*records.reject { it.value.any? && it.value.all? { |elem| elem.start_with?(value) } })
        end
      end

      context "when value is an empty string" do
        let(:value) { "" }

        it "returns all non-empty records" do
          expect(perform_search)
            .to include(*records.select { it.value.any? })
            .and exclude(*records.reject { it.value.any? })
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "returns no records" do
          expect(perform_search).to exclude(*records)
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
