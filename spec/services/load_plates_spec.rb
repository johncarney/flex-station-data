require "flex_station_data/services/load_plates"
require "flex_station_data/services/parse_plate"

RSpec.describe FlexStationData::LoadPlates do
  let(:file)    { double(:file) }
  let(:service) { described_class.new(file) }

  describe "#data" do
    it "reads the file as CSV with no headers", :aggregate_errors do
      expected_data = double(:data)
      csv_data = double(:csv_data, to_a: expected_data)
      expect(CSV).to receive(:read).with(file, headers: false).and_return csv_data
      expect(service.data).to be expected_data
    end
  end

  describe "#data_blocks" do
    let(:csv_data) do
      <<~CSV
        ##BLOCKS= 8,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        Plate:,CatB S1-8 & S33-41 t=24,1.3,PlateFormat,Kinetic,Fluorescence,FALSE,Raw,FALSE,16,1800,120,,,,1,460,1,9,96,360,Automatic,455,,,6,Medium,,,1,8,,0
        Data for Plate #1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ~End ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        Plate:,CatB S42-73 t = 48,1.3,PlateFormat,Kinetic,Fluorescence,FALSE,Raw,FALSE,16,1800,120,,,,1,460,1,12,96,360,Automatic,455,,,6,Medium,,,1,8,,0
        Data for Plate #2,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        ~End ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
      CSV
    end
    let(:data) { CSV.parse(csv_data, headers: false) }

    before do
      allow(service).to receive(:data).and_return data
    end

    it "splits the data into separate block for each plate" do
      expected_blocks = [ data[2...4], data[5...7] ]
      expect(service.data_blocks).to eq expected_blocks
    end
  end

  describe "#call", :aggregate_failures do
    it "returns the plates" do
      block_1 = double(:block_1)
      block_2 = double(:block_1)
      expect(service).to receive(:data_blocks).and_return [ block_1, block_2 ]

      plate_1 = instance_double(FlexStationData::Plate, :plate_1)
      plate_2 = instance_double(FlexStationData::Plate, :plate_2)

      expect(FlexStationData::ParsePlate).to receive(:call).with(anything, block_1).and_return plate_1
      expect(FlexStationData::ParsePlate).to receive(:call).with(anything, block_2).and_return plate_2

      expect(service.call).to eq [ plate_1, plate_2 ]
    end
  end
end
