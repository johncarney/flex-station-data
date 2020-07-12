# frozen_string_literal: true

require "flex_station_data/services/value_quality"

module FlexStationData
  class SampleQuality
    include Concerns::Service

    attr_reader :sample, :options

    def initialize(sample, **options)
      @sample = sample
      @options = options
    end

    def value_quality(value)
      ValueQuality.call(value, **options)
    end

    def call
      sample.values.flatten.map(&method(:value_quality)).uniq(&:to_s)
    end
  end
end
