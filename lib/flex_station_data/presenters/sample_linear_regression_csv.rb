require "flex_station_data/presenters/sample_csv"
require "flex_station_data/linear_regression"

module FlexStationData
  module Presenters
    class SampleLinearRegressionCsv < SampleCsv
      include Concerns::Presenter

      def regression_factory
        LinearRegression.method(:new).curry(2)[times]
      end

      def regressions
        [ *sample.readings, sample.mean ].map(&:values).map(&regression_factory)
      end

      def regressions_csv
        [
          [ "slope", *regressions.map(&:slope) ],
          [ "R²",    *regressions.map(&:r_squared) ]
        ]
      end

      def values_csv
        super + regressions_csv
      end
    end
  end
end
