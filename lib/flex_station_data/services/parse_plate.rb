require "active_support/core_ext"

require "flex_station_data/services/parse_plate_readings"
require "flex_station_data/services/parse_plate_samples"
require "flex_station_data/plate"

module FlexStationData
  class ParsePlate
    include Concerns::Service

    attr_reader :label, :plate_data

    def initialize(label, plate_data)
      @label = label
      @plate_data = plate_data
    end

    def data_blocks
      plate_data.split { |row| row[0] == "~End" }
    end

    def call
      times, temperatures, wells = ParsePlateReadings.call(data_blocks[0])
      samples = ParsePlateSamples.call(data_blocks[1], wells)
      Plate.new(label, times, temperatures, samples)
    end
  end
end
