require "flex_station_data/readings"

module FlexStationData
  class Sample
    attr_reader :label, :readings

    def initialize(label, readings)
      @label = label
      @readings = readings
    end

    def mean
      @mean ||= Readings.mean(*readings)
    end
  end
end
