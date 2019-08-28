require "csv"
require "flex_station_data/services/parse_plate_readings"

RSpec.describe FlexStationData::ParsePlateReadings do
  let(:plate_readings_block_csv) do
    <<~CSV
      ,Temperature(¡C),1,2,,,,,,,,,,,,,,,,,,,
      0:00:00,23.4,2254.922,1842.306,,,,,,,,,,,,,,,,,,,,,,
      ,,2195.008,1803.211,,,,,,,,,,,,,,,,,,,,,,
      ,,,,,,,,,,,,,,,,,,,,,,,,,
      0:02:00,23.5,2343.58,1903.978,,,,,,,,,,,,,,,,,,,,,,
      ,,2248.472,1858.705,,,,,,,,,,,,,,,,,,,,,,
      ,,,,,,,,,,,,,,,,,,,,,,,,,
    CSV
  end

  let(:plate_readings_block) do
    CSV.parse(plate_readings_block_csv, headers: false)
  end

  let(:service) { described_class.new(plate_readings_block) }

  describe "#headers" do
    it "returns the header row of the data block with trailing blanks stripped" do
      expect(service.headers).to eq plate_readings_block.first[0..3]
    end
  end

  describe "#matrix" do
    it "returns the parsed value rows of the data block as a matrix" do
      expect(service.matrix).to eq Matrix[
        [ 0.0, 23.4, 2254.922, 1842.306 ],
        [ nil, nil,  2195.008, 1803.211 ],
        [ 2.0, 23.5, 2343.580, 1903.978 ],
        [ nil, nil,  2248.472, 1858.705 ]
      ]
    end
  end

  describe "#times" do
    it "returns the time values from the plate readings" do
      expect(service.times).to eq [ 0.0, 2.0 ]
    end
  end

  describe "#temperatures" do
    it "returns the temperature values from the plate readings" do
      expect(service.temperatures).to eq [ 23.4, 23.5 ]
    end
  end

  describe "#wells_matrix" do
    it "returns the values from the plate readings organised into wells" do
      expect(service.wells_matrix).to eq Matrix[
        [ [2254.922, 2343.580], [1842.306, 1903.978] ],
        [ [2195.008, 2248.472], [1803.211, 1858.705] ]
      ]
    end
  end

  describe "#wells" do
  end

  describe "#call" do
  end

  describe ".parse_time" do
    it "parses a string in the form H:M:S into decimal minutes" do
      expect(described_class.parse_time("2:10:3")).to eq (2 * 60 + 10 + 3 / 60.0)
    end

    context "given a blank value" do
      it "returns nil" do
        value = double(blank?: true)
        expect(described_class.parse_time(value)).to be_nil
      end
    end
  end

  describe ".parse_value" do
    it "parses a number string into a float value" do
      expect(described_class.parse_value("1.2")).to eq 1.2
    end

    context "given an empty string" do
      it "returns nil" do
        expect(described_class.parse_value("")).to be_nil
      end
    end

    context "given a non-numeric string" do
      it "returns the string" do
        expect(described_class.parse_value("not numeric")).to eq "not numeric"
      end
    end
  end

  describe ".parse_row" do
    it "parses the first value as a time and remaining values as floats", :aggregate_failures do
      expect(described_class).to receive(:parse_time).with("time").and_return :time
      expect(described_class).to receive(:parse_value).with("temperature").and_return :temperature
      expect(described_class).to receive(:parse_value).with("value_1").and_return :value_1
      expect(described_class).to receive(:parse_value).with("value_2").and_return :value_2

      row = %w[ time temperature value_1 value_2 ]

      expect(described_class.parse_row(row)).to eq %i[ time temperature value_1 value_2 ]
    end
  end
end
