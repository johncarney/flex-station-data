require "matrix"

require "flex_station_data/readings"

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
      @mean ||= Readings.mean(*readings)
    end
  end
end
