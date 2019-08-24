require "matrix"

require "flex_station_data/readings"

module FlexStationData
  class Wells
    def initialize(plate_readings_matrix)
      @plate_readings_matrix = plate_readings_matrix
    end

    def values(well_label)
      plate_readings_matrix[*coordinates(well_label)]
    end

    def readings(well_label)
      readings_index[well_label] ||= Readings.new(well_label, values(well_label))
    end

    def coordinates(well_label)
      coordinates_index[well_label] ||= begin
        row, column = well_label.scan(/\A([A-Z])(\d+)\z/).first
        [ row.ord - "A".ord, column.to_i - 1 ]
      end
    end

    private

    def readings_index
      @readings_index ||= {}
    end

    def coordinates_index
      @coordinates_index ||= {}
    end

    attr_reader :plate_readings_matrix
  end
end
