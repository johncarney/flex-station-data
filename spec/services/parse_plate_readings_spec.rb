require "spec_helper"

require "csv"
require "flex_station_data/services/parse_plate_readings"

RSpec.describe FlexStationData::ParsePlateReadings do
  subject { described_class }

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

  describe "#column_count" do
    it "returns the number of value columns" do
      expect(service.column_count).to eq 4
    end
  end

  describe "#parsed_rows" do
    it "parses the rows" do
      expected_rows = [
        [ 0.0, 23.4, 2254.922, 1842.306 ],
        [ nil, nil,  2195.008, 1803.211 ],
        [ 2.0, 23.5, 2343.580, 1903.978 ],
        [ nil, nil,  2248.472, 1858.705 ]
      ]
      expect(service.parsed_rows).to eq expected_rows
    end
  end

  describe "#parsed_columns" do
    it "transposes the parsed rows", :aggregate_failures do
      expect(service).to receive(:parsed_rows).and_return [ [1, 2], [3, 4] ]
      expect(service.parsed_columns).to eq [ [1, 3], [2, 4] ]
    end
  end

  describe "#times" do
    it "returns the time values from the plate readings", :aggregate_failures do
      expect(service).to receive(:parsed_columns).and_return [ [1, nil, 2], [3, nil, 4], [5, 6, 7] ]
      expect(service.times).to eq [ 1, 2 ]
    end
  end

  describe "#temperatures" do
    it "returns the temperature values from the plate readings", :aggregate_failures do
      expect(service).to receive(:parsed_columns).and_return [ [1, nil, 2], [3, nil, 4], [5, 6, 7] ]
      expect(service.temperatures).to eq [ 3, 4 ]
    end
  end

  describe "#values" do
    it "returns the values from the plate readings", :aggregate_failures do
      expect(service).to receive(:parsed_columns).and_return [ [1, nil, 2], [3, nil, 4], [5, 6, 7], [8, 9, 10] ]
      expect(service.values).to eq [ [5, 6, 7], [8, 9, 10] ]
    end
  end

  describe "#wells_row_count" do
    it "returns the number of rows of wells on the plate", :aggregate_failures do
      expect(service.wells_row_count).to eq service.parsed_rows.size / service.times.size
    end
  end

  describe "#plate_readings_matrix" do
    it "returns the plate reading values organised into wells" do
      expected_matrix = [
        [ [2254.922, 2343.580], [1842.306, 1903.978] ],
        [ [2195.008, 2248.472], [1803.211, 1858.705] ]
      ]
      expect(service.plate_readings_matrix).to eq expected_matrix
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
