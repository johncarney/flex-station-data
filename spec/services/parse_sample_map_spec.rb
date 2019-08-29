require "csv"
require "flex_station_data/services/parse_sample_map"

RSpec.describe FlexStationData::ParseSampleMap do
  let(:plate_file) { Pathname(".").join("spec", "fixtures", "plate-data-1.csv") }
  let(:plate_data) { CSV.read(plate_file, headers: false) }

  let(:service) { described_class.new(plate_data) }

  describe "#call" do
    it "returns a hash that maps sample labels to well labels" do
      expected_map = {
        "1" => %w[ A1 A2 ],
        "2" => %w[ B1 B2 ],
        "3" => %w[ A3 A4 ],
        "4" => %w[ B3 B4 ]
      }
      expect(service.call).to eq expected_map
    end
  end
end
