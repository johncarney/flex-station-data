require "flex_station_data/presenters/sample_csv"
require "flex_station_data/presenters/linear_regression/sample_regression_hash"

module FlexStationData
  module Presenters
    module LinearRegression
      class SampleHash
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
end
