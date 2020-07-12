# frozen_string_literal: true

require "flex_station_data/sample"

module FlexStationData
  class Plate
    attr_reader :label, :times, :temperatures, :wells, :sample_map

    def initialize(label, times, temperatures, wells, sample_map)
      @label = label
      @times = times
      @temperatures = temperatures
      @wells = wells
      @sample_map = sample_map
    end

    def samples
      @samples ||= sample_map.map do |label, well_labels|
        Sample.new(label, well_labels, self)
      end
    end
  end
end
