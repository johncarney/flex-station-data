require "flex_station_data/services/compute_mean"

module FlexStationData
  class Readings
    attr_reader :label, :values

    def initialize(label, values)
      @label = label
      @values = values
    end

    def self.mean(*readings, label: "mean")
      new(label, readings.map(&:values).transpose.map(&ComputeMean))
    end
  end
end
