# frozen_string_literal: true

require "matrix"

require "flex_station_data/services/compute_mean"

module FlexStationData
  class Sample
    attr_reader :label, :wells, :plate

    delegate :wells, to: :plate, prefix: true

    def initialize(label, wells, plate)
      @label = label
      @wells = wells
      @plate = plate
    end

    def values
      wells.map(&plate_wells.method(:values))
    end

    def readings
      @readings ||= wells.zip(values).map { |well, v| Readings.new(well, v) }
    end

    def mean
      @mean ||= values.transpose.map(&ComputeMean)
    end
  end
end
