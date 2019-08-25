require "matrix"
require "active_support/core_ext"

require "flex_station_data/concerns/service"

module FlexStationData
  class ParseSampleMap
    include Concerns::Service

    attr_reader :sample_map_block

    def initialize(sample_map_block)
      @sample_map_block = sample_map_block
    end

    def call
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
      row[0] == "Sample"
    end

    def sample_map_rows
      sample_map_block.map(&method(:parse_row)).split(&method(:sample_map_header?)).drop(1).first.split(&method(:empty_row?)).first
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
