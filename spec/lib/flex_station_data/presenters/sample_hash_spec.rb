# frozen_string_literal: true

require "flex_station_data/presenters/sample_hash"

RSpec.describe FlexStationData::Presenters::SampleHash do
  let(:presenter) { described_class.new(times, sample, **options) }

  let(:times)   { [ 0.0, 2.0 ] }
  let(:options) { { option: double(:option) } }

  describe "#present" do
    subject(:hash) { presenter.present }

    let(:mean)    { [ 1000.0, 2000.0 ] }
    let(:sample)  { instance_double(FlexStationData::Sample, :sample, label: "the sample", wells: %w[X1 X2], mean: mean) }
    let(:quality) { FlexStationData::ValueQuality::Good.instance }

    before do
      allow(FlexStationData::SampleQuality).to receive(:call).with(sample, **options).and_return [ quality ]
      allow(FlexStationData::Presenters::SampleRegressionHash).to receive(:present).and_return({})
    end

    it "includes the sample label in the hash" do
      expect(hash).to include "sample" => "the sample"
    end

    it "includes the sample wells in the hash" do
      expect(hash).to include "wells" => "X1, X2"
    end

    context "when the sample does not have errors" do
      let(:quality) { FlexStationData::ValueQuality::Good.instance }

      it "does not includes any errors" do
        expect(hash).to include "error" => nil
      end

      it "computes the linear regression" do
        allow(FlexStationData::Presenters::SampleRegressionHash).to receive(:present).and_return({})
        presenter.present
        expect(FlexStationData::Presenters::SampleRegressionHash).to have_received(:present).with(times, mean, **options)
      end

      it "returns an array of hashes with data from the file's plates", :aggregate_failures do
        regression_hash = { "regression" => [1.0] }
        expect(FlexStationData::Presenters::SampleRegressionHash).to receive(:present).with(times, mean, **options).and_return(regression_hash)

        expect(hash).to include regression_hash.transform_values(&:first)
      end
    end

    context "when the sample has errors" do
      let(:quality) { FlexStationData::ValueQuality::Bad.new("Bad") }

      it "includes the errors in the hash" do
        expect(hash).to include "error" => "Bad"
      end

      it "does not compute the linear regression" do
        allow(FlexStationData::Presenters::SampleRegressionHash).to receive(:present).and_return({})
        presenter.present
        expect(FlexStationData::Presenters::SampleRegressionHash).to_not have_received(:present)
      end

      it "leaves the linear regression values blank" do
        regression_headers = FlexStationData::Presenters::SampleRegressionHash.headers
        expected_regression_hash = regression_headers.zip([]).to_h
        expect(hash).to include expected_regression_hash
      end
    end
  end
end
