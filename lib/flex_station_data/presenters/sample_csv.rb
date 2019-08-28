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

      def errors
        @errors ||= quality_control.call(sample, **options).reject(&:good?)
      end

      def present
        [
          [ label ],
          *body_csv,
          [ ]
        ]
      end

      private

      def label
        "Sample #{sample.label}"
      end

      def errors?
        errors.present?
      end

      def errors_csv
        errors.map(&:to_s).map(&method(:Array))
      end

      def headers
        [ "time", *sample.wells, "mean" ]
      end

      def values
        [ times, *sample.values, sample.mean ]
      end

      def values_csv
        [ headers, *values.transpose ]
      end

      def body_csv
        errors? ? errors_csv : values_csv
      end
    end
  end
end
