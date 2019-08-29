require "matrix"
require "active_support/core_ext"

require "flex_station_data/concerns/service"

module FlexStationData
  class ParseSampleMap
    include Concerns::Service

    attr_reader :plate_data

    def initialize(plate_data)
      @plate_data = plate_data
    end

    def call
      return {} if matrix.empty?

      labels.zip(matrix.column(1).to_a.each_slice(wells_per_sample).to_a).to_h
    end

    private

    def parse_row(row)
      row.take(2).map(&:presence)
    end

    def empty_row?(row)
      row.all?(&:blank?)
    end

    def sample_map_header?(row)
      row[0].to_s =~ /\A\s*Sample\s*\z/i && row[1].to_s =~ /\A\s*Wells\s*\z/i
    end

    def sample_map_rows
      plate_data
        .drop_while { |row| !sample_map_header?(row) }
        .drop(1)
        .take_while { |row| !empty_row?(row) }
        .map(&method(:parse_row))
    end

    def matrix
      @matrix ||= Matrix[*sample_map_rows]
    end

    def labels
      @labels ||= matrix.column(0).to_a.compact
    end

    def wells_per_sample
      matrix.row_count / labels.size
    end
  end
end
