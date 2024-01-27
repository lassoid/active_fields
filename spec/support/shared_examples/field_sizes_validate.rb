# frozen_string_literal: true

RSpec.shared_examples "field_sizes_validate" do |factory:|
  describe "#min_size" do
    let(:record) { build(factory, min_size: min_size) }

    context "without min_size" do
      let(:min_size) { nil }

      it "is valid" do
        record.valid?

        expect(record.errors.where(:min_size)).to be_empty
      end
    end

    context "when min_size is negative" do
      let(:min_size) { rand(-10..-1) }

      it "is invalid" do
        record.valid?

        expect(record.errors.where(:min_size, :greater_than_or_equal_to, count: 0)).not_to be_empty
      end
    end

    context "when min_size is zero" do
      let(:min_size) { 0 }

      it "is valid" do
        record.valid?

        expect(record.errors.where(:min_size)).to be_empty
      end
    end

    context "when min_size is positive" do
      let(:min_size) { rand(1..10) }

      it "is valid" do
        record.valid?

        expect(record.errors.where(:min_size)).to be_empty
      end
    end
  end

  describe "#max_size" do
    let(:record) { build(factory, min_size: min_size, max_size: max_size) }

    context "without min_size" do
      let(:min_size) { nil }

      context "without max_size" do
        let(:max_size) { nil }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:max_size)).to be_empty
        end
      end

      context "when max_size is negative" do
        let(:max_size) { rand(-10..-1) }

        it "is invalid" do
          record.valid?

          expect(record.errors.where(:max_size, :greater_than_or_equal_to, count: 0)).not_to be_empty
        end
      end

      context "when max_size is zero" do
        let(:max_size) { 0 }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:max_size)).to be_empty
        end
      end

      context "when max_size is positive" do
        let(:max_size) { rand(1..10) }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:max_size)).to be_empty
        end
      end
    end

    context "with min_size" do
      let(:min_size) { rand(1..10) }

      context "without max_size" do
        let(:max_size) { nil }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:max_size)).to be_empty
        end
      end

      context "when max_size is less than min_size" do
        let(:max_size) { min_size - 1 }

        it "is invalid" do
          record.valid?

          expect(record.errors.where(:max_size, :greater_than_or_equal_to, count: min_size)).not_to be_empty
        end
      end

      context "when max_size is equal to min_size" do
        let(:max_size) { min_size }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:max_size)).to be_empty
        end
      end

      context "when max_size is greater than min_size" do
        let(:max_size) { min_size + 1 }

        it "is valid" do
          record.valid?

          expect(record.errors.where(:max_size)).to be_empty
        end
      end
    end
  end
end
