require "active_support/core_ext"
require "matrix"

require "flex_station_data/wells"
require "flex_station_data/concerns/service"

module FlexStationData
  class ParsePlateReadings
    include Concerns::Service

    delegate :parse_time, :parse_value, :parse_row, to: :class

    def initialize(plate_readings_block)
      @plate_readings_block = plate_readings_block
    end

    def headers
      @headers ||= plate_readings_block.first.reverse.drop_while(&:blank?).reverse
    end

    def matrix
      @matrix ||= Matrix[
        *plate_readings_block.drop(1).map { |row| parse_row(row[0...headers.size]) }.select { |row| row.any?(&:present?) }
      ]
    end

    def times
      @times ||= matrix.column(0).to_a.compact
    end

    def temperatures
      @temperatures ||= matrix.column(1).to_a.compact
    end

    def wells_matrix
      well_row_count = matrix.row_count / times.size
      rows = well_values.column_vectors.map do |column|
        column.to_a.each_slice(well_row_count).to_a.transpose
      end.transpose
      Matrix[*rows]
    end

    def wells
      Wells.new(wells_matrix)
    end

    def call
      [ times, temperatures, wells ]
    end

    class << self
      def parse_time(t)
        return if t.blank?

        h, m, s = t.split(":").map(&:to_i)
        h * 60.0 + m + s / 60.0
      end

      def parse_value(v)
        return Float(v) rescue v.presence
      end

      def parse_row(row)
        time, temperature, *values = row
        [ parse_time(time), parse_value(temperature), *values.map(&method(:parse_value)) ]
      end
    end

    private

    def well_values
      matrix.minor(0..-1, 2..-1)
    end

    attr_reader :plate_readings_block
  end
end
