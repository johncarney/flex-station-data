require "flex_station_data/concerns/presenter"
require "flex_station_data/readings"
require "flex_station_data/services/sample_quality"

module FlexStationData
  module Presenters
    class SampleCsv
      include Concerns::Presenter

      attr_reader :times, :sample, :quality_control

      def initialize(times, sample, quality_control: SampleQuality)
        @times = times
        @sample = sample
        @quality_control = quality_control
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

      def errors
        @errors ||= quality_control.call(sample).reject(&:good?)
      end

      def errors?
        errors.present?
      end

      def errors_csv
        errors.map(&:to_s).map(&method(:Array))
      end

      def values_csv
        [ headers, *rows ]
      end

      def present
        [ [label] ] + (errors? ? errors_csv : values_csv) + [ [] ]
      end
    end
  end
end
