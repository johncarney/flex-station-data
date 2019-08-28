require "flex_station_data/wells"
require "flex_station_data/plate"
require "flex_station_data/sample"

RSpec.describe FlexStationData::Sample do
  let(:sample) { described_class.new(label, wells, plate) }

  let(:label) { "a sample" }

  let(:wells) { %w[ B3 B4 ] }

  let(:plate_wells) do
    FlexStationData::Wells.new Matrix[
      [ %i[a], %i[b], %i[c], %i[d] ],
      [ %i[e], %i[f], %i[g], %i[h] ]
    ]
  end

  let(:plate) { instance_double(FlexStationData::Plate, wells: plate_wells) }

  describe "#values" do
    subject(:values) { sample.values }

    it "returns the values of the sample wells" do
      expect(values).to eq [ %i[g], %i[h] ]
    end
  end

  describe ".mean" do
    it "returns values that are the mean of the sample values", :aggregate_failures do
      values_1 = [ 1, 2, 3 ]
      values_2 = [ 4, 5, 6 ]
      mean     = values_1.zip(values_2).map(&FlexStationData::ComputeMean)

      allow(sample).to receive(:values).and_return [ values_1, values_2 ]

      expect(sample.mean).to eq mean
    end
  end
end
