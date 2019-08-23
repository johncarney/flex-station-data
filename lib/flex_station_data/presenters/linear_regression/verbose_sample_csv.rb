require "flex_station_data/presenters/sample_csv"
require "flex_station_data/presenters/linear_regression/sample_regression_hash"

module FlexStationData
  module Presenters
    module LinearRegression
      class VerboseSampleCsv < Presenters::SampleCsv
        include Concerns::Presenter

        def regression_factory
          FlexStationData::LinearRegression.method(:new).curry(2)[times]
        end

        def regressions
          [ *sample.readings, sample.mean ].map(&:values).map(&regression_factory)
        end

        def sample_values
          [ *sample.readings, sample.mean ].map(&:values)
        end

        def regressions_hash
          SampleRegressionHash.present(times, *sample_values)
        end

        def regressions_csv
          regressions_hash.to_a.map(&:flatten)
        end

        def values_csv
          super + regressions_csv
        end
      end
    end
  end
end
