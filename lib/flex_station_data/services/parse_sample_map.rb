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

    def sample_map_rows
      plate_data
        .drop_while { |row| !sample_map_header?(row) }
        .drop(1)
        .take_while { |row| !empty_row?(row) }
        .map(&method(:parse_row))
    end

    def call
      sample_map_rows.each_with_object([]) do |(label, well), memo|
        memo << [ label, [] ] if label.present?
        memo.last.last << well
      end.to_h
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
  end
end
