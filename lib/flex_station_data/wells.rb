require "flex_station_data/readings"

module FlexStationData
  class Wells
    def initialize(plate_readings_matrix)
      @plate_readings_matrix = plate_readings_matrix
    end

    def readings(well_label)
      well_index[well_label] ||= begin
        row, column = well_label.chars
        Readings.new(well_label, plate_readings_matrix[row.ord - "A".ord][column.to_i - 1])
      end
    end

    private

    def well_index
      @well_index ||= {}
    end

    attr_reader :plate_readings_matrix
  end
end
