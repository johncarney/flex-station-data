require "flex_station_data/wells"
require "flex_station_data/plate"
require "flex_station_data/sample"

require "support/readings_matchers"

RSpec.describe FlexStationData::Sample do
  include ReadingsMatchers

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

  describe "#readings" do
    subject(:readings) { sample.readings }

    it "returns readings for each sample well" do
      expected_readings = [ ["B3",  %i[g]], ["B4", %i[h]] ].map do |label, values|
        FlexStationData::Readings.new(label, values)
      end

      expect(readings).to match expected_readings.map(&method(:match_readings))
    end
  end

  describe ".mean" do
    it "returns readings that are the mean of the sample readings", :aggregate_failures do
      readings_1 = instance_double(FlexStationData::Readings, :readings_1)
      readings_2 = instance_double(FlexStationData::Readings, :readings_1)
      readings_mean = instance_double(FlexStationData::Readings, :readings_mean)
      expect(FlexStationData::Readings).to receive(:mean).with(readings_1, readings_2).and_return readings_mean

      allow(sample).to receive(:readings).and_return [ readings_1, readings_2 ]

      expect(sample.mean).to be readings_mean
    end
  end
end
