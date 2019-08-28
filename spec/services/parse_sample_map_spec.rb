require "csv"
require "flex_station_data/services/parse_sample_map"

RSpec.describe FlexStationData::ParseSampleMap do
  let(:plate_samples_block_csv) do
    <<~CSV
      Group: Unknowns,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
      Sample,Wells,Value,R,Result,MeanResult,SD,CV,,,,,,,,,,,,,,,,,,,,,,,,,
      1,A1,0.791,R, , , , ,,,,,,,,,,,,,,,,,,,,,,,,,
       ,A2,0.684,R, , , , ,,,,,,,,,,,,,,,,,,,,,,,,,
      3,C1,0.84,R, , , , ,,,,,,,,,,,,,,,,,,,,,,,,,
       ,C2,0.61,R, , , , ,,,,,,,,,,,,,,,,,,,,,,,,,
      ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    CSV
  end

  let(:plate_samples_block) do
    CSV.parse(plate_samples_block_csv, headers: false)
  end

  let(:service) { described_class.new(plate_samples_block) }

  describe "#call" do
    it "returns a hash that maps sample labels to well labels" do
      expected_map = {
        "1" => %w[ A1 A2 ],
        "3" => %w[ C1 C2 ]
      }
      expect(service.call).to eq expected_map
    end
  end
end
