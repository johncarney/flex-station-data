require "flex_station_data/linear_regression"

module FlexStationData
  module Presenters
    module LinearRegression
      class SampleRegressionHash
        include Concerns::Presenter

        PRODUCTS = {
          slope:     "slope",
          intercept: "intercept",
          r_squared: "R²",
          quality:   "quality"
        }.freeze

        attr_reader :times, :sample_values, :min_r_squared, :options

        def initialize(times, *sample_values, min_r_squared: nil, **options)
          @times = times
          @sample_values = sample_values
          @min_r_squared = min_r_squared
          @options = options
        end

        def sample_regressions
          @sample_regressions ||= sample_values.map do |values|
            FlexStationData::LinearRegression.new(times, values, min_r_squared: min_r_squared)
          end
        end

        def present
          PRODUCTS.each_with_object({}) do |(method, label), memo|
            memo[label] = sample_regressions.map(&method)
          end
        end

        def self.headers
          PRODUCTS.values
        end
      end
    end
  end
end
