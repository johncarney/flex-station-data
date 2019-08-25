require "matrix"

module FlexStationData
  class Wells
    attr_reader :matrix

    def initialize(matrix)
      @matrix = matrix
    end

    def values(well_label)
      matrix[*coordinates(well_label)]
    end

    def coordinates(well_label)
      coordinates_index[well_label] ||= begin
        row, column = well_label.scan(/\A([A-Z])(\d+)\z/).first
        [ row.ord - "A".ord, column.to_i - 1 ]
      end
    end

    private

    def coordinates_index
      @coordinates_index ||= {}
    end
  end
end
