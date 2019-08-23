require "flex_station_data/concerns/presenter"
require "flex_station_data/readings"

module FlexStationData
  module Presenters
    class SampleCsv
      include Concerns::Presenter

      attr_reader :times, :sample

      def initialize(times, sample)
        @times = times
        @sample = sample
      end

      def readings
        @readings ||= [ Readings.new("time", times), *sample.readings, sample.mean ]
      end

      def headers
        readings.map(&:label)
      end

      def rows
        readings.map(&:values).transpose
      end

      def label
        "Sample #{sample.label}"
      end

      def present
        [ [label], headers, *rows ]
      end
    end
  end
end
