require "flex_station_data/services/compute_mean"

RSpec.describe FlexStationData::ComputeMean do
  let(:service) { described_class.new(values) }

  describe "#call" do
    let(:values) { [ 2, 3, 6 ] }

    it "computes the mean of the given values" do
      expect(service.call).to eq values.sum / values.size.to_f
    end

    context "given non-numeric values" do
      let(:values) { %w[ A B C ] }

      it "returns nil" do
        expect(service.call).to be_nil
      end
    end

    context "given mixed numeric and non-numeric values" do
      let(:values) { [ 1, "B", 2, "C", 3 ] }

      it "returns nil" do
        expect(service.call).to be_nil
      end
    end

    context "given nil values" do
      let(:values) { [ nil, nil ] }

      it "returns nil" do
        expect(service.call).to be_nil
      end
    end

    context "given mixed numeric and nil values" do
      let(:values) { [ 1, nil, 2 ] }

      it "returns nil" do
        expect(service.call).to be_nil
      end
    end

    context "given no values" do
      let(:values) { [] }

      it "returns NaN" do
        expect(service.call).to be_nan
      end
    end
  end
end
