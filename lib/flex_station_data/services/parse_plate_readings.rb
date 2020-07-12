# frozen_string_literal: true

require "active_support/core_ext"
require "matrix"

require "flex_station_data/wells"
require "flex_station_data/concerns/service"

module FlexStationData
  class ParsePlateReadings
    include Concerns::Service

    delegate :parse_time, :parse_value, :parse_row, to: :class

    def initialize(plate_data)
      @plate_data = plate_data
    end

    def readings_block
      @readings_block ||= plate_data
        .drop_while { |row| !header_row?(row) }
        .drop_while { |row| !sample_row?(row) }
        .take_while { |row| !end_row?(row) }
        .select     { |row| row.any?(&:present?) }
    end

    def headers
      @headers ||= plate_data.detect(&method(:header_row?)).reverse.drop_while(&:blank?).reverse
    end

    def times
      @times ||= matrix.column(0).to_a.compact
    end

    def temperatures
      @temperatures ||= matrix.column(1).to_a.compact
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
        Float(v)
      rescue ArgumentError, TypeError
        v.presence
      end

      def parse_row(row)
        time, temperature, *values = row
        [ parse_time(time), parse_value(temperature), *values.map(&method(:parse_value)) ]
      end
    end

    private

    def header_row?(row)
      row[1].to_s =~ /\A\s*Temperature\b/i
    end

    def sample_row?(row)
      row[0].to_s =~ /\A\s*\d+:\d+:\d+\s*\z/
    end

    def end_row?(row)
      row[0].to_s =~ /\A\s*~End\s*\z/i
    end

    def well_values
      matrix.minor(0..-1, 2..-1)
    end

    def matrix
      @matrix ||= Matrix[
        *readings_block.map { |row| parse_row(row[0...headers.size]) }
      ]
    end

    def wells_matrix
      well_row_count = matrix.row_count / times.size
      Matrix[*well_values.column_vectors.map { |col| col.to_a.each_slice(well_row_count).to_a.transpose }.transpose]
    end

    attr_reader :plate_data
  end
end
