require "flex_station_data/sample"

RSpec.describe FlexStationData::Sample do
  describe ".mean" do
    it "returns readings that are the mean of the sample readings" do
      readings_1 = instance_double(FlexStationData::Readings, :readings_1)
      readings_2 = instance_double(FlexStationData::Readings, :readings_1)
      readings_mean = instance_double(FlexStationData::Readings, :readings_mean)
      expect(FlexStationData::Readings).to receive(:mean).with(readings_1, readings_2).and_return readings_mean

      samples = described_class.new("1", [ readings_1, readings_2 ])
      expect(samples.mean).to be readings_mean
    end
  end
end
