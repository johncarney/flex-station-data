require "flex_station_data/presenters/sample_csv"
require "flex_station_data/linear_regression"

module FlexStationData
  module Presenters
    class SampleLinearRegressionCsv
      include Concerns::Presenter

      attr_reader :times, :sample

      def initialize(times, sample)
        @times = times
        @sample = sample
      end

      def regression_factory
        LinearRegression.method(:new).curry(2)[times]
      end

      def readings
        [ *sample.readings, sample.mean ]
      end

      def regressions
        readings.map(&:values).map(&regression_factory)
      end

      def regressions_csv
        [
          [ "slope", *regressions.map(&:slope) ],
          [ "R²",    *regressions.map(&:r_squared) ]
        ]
      end

      def present
        SampleCsv.present(times, sample) + regressions_csv
      end
    end
  end
end
