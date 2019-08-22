require "active_support/core_ext"

require "flex_station_data/concerns/service"

module FlexStationData
  class ParsePlateReadings
    include Concerns::Service

    delegate :parse_time, :parse_value, :parse_row, to: :class

    def initialize(plate_readings_block)
      @plate_readings_block = plate_readings_block
    end

    def column_count
      @column_count ||= headers.reverse.drop_while(&:blank?).size
    end

    def parsed_rows
      @parsed_rows ||= begin
        rows = plate_readings_data.map { |row| parse_row(row[0...column_count]) }
        rows.select { |row| row.any?(&:present?) }
      end
    end

    def parsed_columns
      @parsed_columns ||= parsed_rows.transpose
    end

    def times
      @times ||= parsed_columns[0].compact
    end

    def temperatures
      @temperatures ||= parsed_columns[1].compact
    end

    def values
      @values ||= parsed_columns.drop(2)
    end

    def wells_row_count
      parsed_rows.size / times.size
    end

    def plate_readings_matrix
      values.map do |values_column|
        values_column.each_slice(wells_row_count).to_a.transpose
      end.transpose
    end

    def wells
      Wells.new(plate_readings_matrix)
    end

    def call
      [ times. temperatures. wells ]
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

    def headers
      plate_readings_block.first
    end

    def plate_readings_data
      @plate_readings_data ||= plate_readings_block.drop(1)
    end

    attr_reader :plate_readings_block
  end
end
