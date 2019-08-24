require "flex_station_data/services/value_quality"

module FlexStationData
  class SampleQuality
    include Concerns::Service

    attr_reader :sample, :value_quality_control, :options

    def initialize(sample, value_quality_control: ValueQuality, **options)
      @sample = sample
      @value_quality_control = value_quality_control
      @options = options
    end

    def value_quality(value)
      value_quality_control.call(value, **options)
    end

    def call
      sample.readings.flat_map(&:values).map(&method(:value_quality)).uniq(&:to_s)
    end
  end
end
