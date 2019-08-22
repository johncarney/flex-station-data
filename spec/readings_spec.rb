require "flex_station_data/readings"

RSpec.describe FlexStationData::Readings do
  describe ".mean" do
    it "returns the readings with the mean for each reading value across the supplied readings", :aggregate_failures do
      reading_1 = described_class.new("A", [ 1, 2, 3 ])
      reading_2 = described_class.new("B", [ 4, 5, 6 ])
      reading_3 = described_class.new("B", [ 7, 8, 9 ])

      mean_1 = double(:mean_1)
      mean_2 = double(:mean_2)
      mean_3 = double(:mean_3)
      expect(FlexStationData::ComputeMean).to receive(:call).with([1, 4, 7]).and_return mean_1
      expect(FlexStationData::ComputeMean).to receive(:call).with([2, 5, 8]).and_return mean_2
      expect(FlexStationData::ComputeMean).to receive(:call).with([3, 6, 9]).and_return mean_3

      expect(described_class.mean(reading_1, reading_2, reading_3).values).to eq([ mean_1, mean_2, mean_3 ])
    end

    context "without a label" do
      it "defaults to 'mean'" do
        expect(described_class.mean.label).to eq "mean"
      end
    end

    context "with a label" do
      it "uses the supplied label" do
        expect(described_class.mean(label: "custom label").label).to eq "custom label"
      end
    end
  end
end
