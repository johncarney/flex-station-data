# frozen_string_literal: true

require "csv"
require "flex_station_data/services/parse_plate_readings"

require "support/wells_matchers"

RSpec.describe FlexStationData::ParsePlateReadings do
  include WellsMatchers

  let(:plate_file) { Pathname(".").join("spec", "fixtures", "plate-data-1.csv") }
  let(:plate_data) { CSV.read(plate_file, headers: false) }

  let(:service) { described_class.new(plate_data) }

  describe "#readings_block" do
    it "returns the section of the plate data that contains the readings with empty rows removed" do
      expected_block = plate_data[2...7].select { |row| row.any?(&:present?) }
      expect(service.readings_block).to eq expected_block
    end
  end

  describe "#headers" do
    it "returns the header row of the data block with trailing blanks stripped" do
      expect(service.headers).to eq plate_data[1][0...8]
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

  describe "#wells" do
    subject(:wells) { service.wells }

    it "returns a Wells object with the plate readings" do
      expect(wells).to be_a_wells_object.with_matrix Matrix[
        [ [2254.922, 2343.580], [1842.306, 1903.978], [1872.553, 1933.736], [1689.320, 1769.879], [nil, nil], [nil, nil] ],
        [ [2195.008, 2248.472], [1803.211, 1858.705], [1736.510, 1785.939], [1698.474, 1774.720], [nil, nil], [nil, nil] ]
      ]
    end
  end

  describe "#call" do
    subject(:times_temperatures_and_wells) { service.call }

    it "returns the times, temperatures, and wells" do
      wells = instance_double(FlexStationData::Wells, :wells)
      allow(service).to receive(:wells).and_return wells

      expect(times_temperatures_and_wells).to eq [ [0.0, 2.0], [23.4, 23.5], wells ]
    end
  end

  describe ".parse_time" do
    it "parses a string in the form H:M:S into decimal minutes" do
      expect(described_class.parse_time("2:10:3")).to eq(2 * 60 + 10 + 3 / 60.0)
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
