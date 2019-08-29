require "csv"
require "flex_station_data/services/parse_sample_map"

RSpec.describe FlexStationData::ParseSampleMap do
  let(:plate_file) { Pathname(".").join("spec", "fixtures", "plate-data-1.csv") }
  let(:plate_data) { CSV.read(plate_file, headers: false) }

  let(:service) { described_class.new(plate_data) }

  describe "#sample_map_rows" do
    it "extracts the sample map rows from the plate data" do
      expect(service.sample_map_rows).to eq [
        [ "1",  "A1" ],
        [ nil,  "A2" ],
        [ "2",  "B1" ],
        [ nil,  "B2" ],
        [ "3",  "A3" ],
        [ nil,  "A4" ],
        [ "4",  "B3" ],
        [ nil,  "B4" ]
      ]
    end
  end

  describe "#call" do
    subject(:sample_map) { service.call }

    matcher :map_sample do |label|
      match do |map|
        map[label] == @wells
      end

      chain :to do |*wells|
        @wells = wells
      end
    end

    before do
      allow(service).to receive(:sample_map_rows).and_return sample_map_rows
    end

    context "given a regular sample map" do
      let(:sample_map_rows) do
        [
          [ "1",  "A1" ],
          [ nil,  "A2" ],
          [ "3",  "Z1" ],
          [ nil,  "Z2" ]
        ]
      end

      it "maps sample labels to wells", :aggregate_failures do
        expect(sample_map).to map_sample("1").to "A1", "A2"
        expect(sample_map).to map_sample("3").to "Z1", "Z2"
      end
    end


    context "given an irregular sample map" do
      let(:sample_map_rows) do
        [
          [ "1",  "A1" ],
          [ nil,  "A2" ],
          [ "3",  "Z1" ],
          [ nil,  "Z2" ],
          [ nil,  "Z3" ]
        ]
      end

      it "maps sample labels to wells", :aggregate_failures do
        expect(sample_map).to map_sample("1").to "A1", "A2"
        expect(sample_map).to map_sample("3").to "Z1", "Z2", "Z3"
      end
    end

    context "given plate data without a sample map" do
      let(:sample_map_rows) { [] }

      it { is_expected.to be_empty }
    end
  end
end
