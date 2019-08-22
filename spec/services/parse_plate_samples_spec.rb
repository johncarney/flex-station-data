require "csv"
require "flex_station_data/services/parse_plate_samples"

RSpec.describe FlexStationData::ParsePlateSamples do
  let(:plate_samples_block_csv) do
    <<~CSV
      Group: Unknowns,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
      Sample,Wells,Value,R,Result,MeanResult,SD,CV,,,,,,,,,,,,,,,,,,,,,,,,,
      1,A1,0.791,R, , , , ,,,,,,,,,,,,,,,,,,,,,,,,,
      ,A2,0.684,R, , , , ,,,,,,,,,,,,,,,,,,,,,,,,,
      2,B1,0.84,R, , , , ,,,,,,,,,,,,,,,,,,,,,,,,,
      ,B2,0.61,R, , , , ,,,,,,,,,,,,,,,,,,,,,,,,,
      ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    CSV
  end

  let(:plate_samples_block) do
    CSV.parse(plate_samples_block_csv, headers: false)
  end

  let(:wells) { instance_double(FlexStationData::Wells) }

  let(:service) { described_class.new(plate_samples_block, wells) }

  describe "#map_rows" do
    it "returns the sample map rows from the samples block" do
      expect(service.map_rows).to eq plate_samples_block[2...-1]
    end
  end

  describe "#map_columns" do
    it "transposes the map rows", :aggregate_failures do
      expect(service).to receive(:map_rows).and_return [ [1, 2], [3, 4] ]
      expect(service.map_columns).to eq [ [1, 3], [2, 4] ]
    end
  end

  describe "#labels" do
    it "returns the sample labels from the sample map", :aggregate_failures do
      expect(service).to receive(:map_columns).and_return [ [1, nil, 2], [3, nil, 4], [5, 6, 7] ]
      expect(service.labels).to eq [ 1, 2 ]
    end
  end

  describe "#wells_per_sample" do
    it "returns the number of wells in each sample" do
      expect(service.wells_per_sample).to eq service.map_rows.size / service.labels.size
    end
  end

  describe "#sample_map" do
    it "returns the well labels for each sample" do
      expect(service.sample_map).to eq [ %w[ A1 A2 ], %w[ B1 B2 ] ]
    end
  end

  describe "#call" do
    it "maps the well readings into samples", :aggregate_failures do
      expect(wells).to receive(:readings).with("A1").and_return :a1
      expect(wells).to receive(:readings).with("A2").and_return :a2
      expect(wells).to receive(:readings).with("B1").and_return :b1
      expect(wells).to receive(:readings).with("B2").and_return :b2

      expect(FlexStationData::Sample).to receive(:new).with("1", [:a1, :a2]).and_return :sample_1
      expect(FlexStationData::Sample).to receive(:new).with("2", [:b1, :b2]).and_return :sample_2

      expect(service.call).to eq %i[ sample_1 sample_2 ]
    end
  end
end
