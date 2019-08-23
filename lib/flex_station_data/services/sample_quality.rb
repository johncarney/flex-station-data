require "flex_station_data/services/value_quality"

module FlexStationData
  class SampleQuality
    include Concerns::Service

    attr_reader :sample, :value_quality_control

    def initialize(sample, value_quality_control: ValueQuality)
      @sample = sample
      @value_quality_control = value_quality_control
    end

    def call
      sample.readings.flat_map(&:values).map(&value_quality_control).uniq(&:to_s)
    end
  end
end
