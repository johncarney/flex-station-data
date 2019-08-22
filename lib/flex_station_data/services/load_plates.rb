require "csv"
require "active_support/core_ext"

require "flex_station_data/services/parse_plate"

module FlexStationData
  class LoadPlates
    include Concerns::Service

    attr_reader :file

    def initialize(file)
      @file = file
    end

    def data
      CSV.read(file, headers: false).to_a
    end

    def data_blocks
      @data_blocks ||= data.split { |row| row[0] == "Plate:" }.drop(1)
    end

    def call
      data_blocks.map(&FlexStationData::ParsePlate.method(:call))
    end
  end
end
