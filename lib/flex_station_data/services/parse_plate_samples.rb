require "flex_station_data/readings"
require "flex_station_data/concerns/service"

require "flex_station_data/sample"

module FlexStationData
  class ParsePlateSamples
    include Concerns::Service

    def initialize(sample_map_block, wells)
      @sample_map_block = sample_map_block
      @wells = wells
    end

    def map_rows
      @map_rows ||= begin
        rows = sample_map_block.drop_while { |row| row[0] != "Sample" }.drop(1)
        rows = rows.map { |row| row.map(&:presence) }
        rows.take_while { |row| row.any?(&:present?) }.to_a
      end
    end

    def map_columns
      @map_columns ||= map_rows.transpose
    end

    def labels
      @labels ||= map_columns[0].compact
    end

    def wells_per_sample
      map_rows.size / labels.size
    end

    def sample_map
      @sample_map ||= map_columns[1].each_slice(wells_per_sample).to_a
    end

    def call
      labels.zip(sample_map).map do |label, well_labels|
        Sample.new(label, well_labels.map(&wells.method(:readings)))
      end
    end

    private

    attr_reader :sample_map_block, :wells
  end
end
