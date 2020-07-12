# frozen_string_literal: true

require "flex_station_data/presenters/sample_regression_hash"

RSpec.describe FlexStationData::Presenters::SampleRegressionHash do
  let(:presenter) { described_class.new(times, *sample_values, min_r_squared: min_r_squared, **options) }

  let(:times)         { [ 0.0, 2.0, 4.0 ] }
  let(:options)       { { option: double(:option) } }
  let(:min_r_squared) { nil }
  let(:sample_values) do
    [
      [   1.0,  2.0,  3.0 ],
      [   4.0,  4.0,  4.0 ],
      [  6.78, 6.84, 6.81 ],
      [ 4.001,  4.1, 4.18 ]
    ]
  end

  let(:regression_class) { FlexStationData::LinearRegression }

  describe "#present" do
    subject(:hash) { presenter.present }

    it "returns linear regression coefficients for each set of sample values" do
      expected_hash = {
        "R²"        => [ 1.0, 1.0, 0.25000000000356215,  0.9962584469954767  ],
        "intercept" => [ 1.0, 4.0, 6.794999999999999,    4.004166666666666   ],
        "quality"   => [ nil, nil, nil,                  nil                 ],
        "slope"     => [ 0.5, 0.0, 0.007500000000000284, 0.04475000000000007 ]
      }
      expect(hash).to eq expected_hash
    end

    context "given a minimum R² value" do
      let(:min_r_squared) { 0.999 }

      it %(flags samples with an R² below the minimum as "poor fits") do
        expect(hash["quality"]).to eq [ nil, nil, "poor fit", "poor fit" ]
      end
    end
  end
end
