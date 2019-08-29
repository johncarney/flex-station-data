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
      @data_blocks ||= data.each_with_object([]) do |row, blocks|
        blocks << [] if plate_row?(row)
        blocks.last&.push(row)
      end
    end

    def call
      data_blocks.each_with_index.map do |data_block, index|
        FlexStationData::ParsePlate.call(index + 1, data_block)
      end
    end

    private

    def plate_row?(row)
      row[0].to_s =~ /\A\s*Plate:\s*/i
    end
  end
end
