require "flex_station_data/concerns/presenter"
require "flex_station_data/services/sample_quality"

module FlexStationData
  module Presenters
    class SampleCsv
      include Concerns::Presenter

      attr_reader :times, :sample, :quality_control, :options

      def initialize(times, sample, quality_control: SampleQuality, **options)
        @times = times
        @sample = sample
        @quality_control = quality_control
        @options = options
      end

      def values
        @values ||= [ times, *sample.values, sample.mean ]
      end

      def headers
        @headers ||= [ "time", *sample.wells, "mean" ]
      end

      def rows
        values.transpose
      end

      def label
        "Sample #{sample.label}"
      end

      def errors
        @errors ||= quality_control.call(sample, **options).reject(&:good?)
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
