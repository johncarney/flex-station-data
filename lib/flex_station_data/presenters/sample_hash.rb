require "flex_station_data/concerns/presenter"
require "flex_station_data/services/sample_quality"
require "flex_station_data/presenters/sample_regression_hash"

module FlexStationData
  module Presenters
    class SampleHash
      include Concerns::Presenter

      attr_reader :times, :sample, :quality_control, :options

      def initialize(times, sample, **options)
        @times = times
        @sample = sample
        @options = options
      end

      def errors
        @errors ||= SampleQuality.call(sample, **options).reject(&:good?)
      end

      def errors?
        errors.present?
      end

      def errors_hash
        { "error" => errors.first&.to_s }
      end

      def wells_hash
        { "wells" => sample.wells.join(", ") }
      end

      def regression_hash
        return SampleRegressionHash.headers.zip([]).to_h if errors?

        SampleRegressionHash.present(times, sample.mean, **options).transform_values(&:first)
      end

      def present
        { "sample" => sample.label }.merge(wells_hash).merge(errors_hash).merge(regression_hash)
      end
    end
  end
end
