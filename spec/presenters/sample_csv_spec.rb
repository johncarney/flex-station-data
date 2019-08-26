require "flex_station_data/presenters/sample_csv"

require "flex_station_data/sample"

RSpec.describe FlexStationData::Presenters::SampleCsv do
  let(:presenter) { described_class.new(times, sample, quality_control: quality_control, **options) }

  let(:times)           { [ 0.0, 2.0 ] }
  let(:quality_control) { FlexStationData::SampleQuality }
  let(:options)         { { an_option: "value"} }

  let(:sample) { instance_double(FlexStationData::Sample, :sample, label: "A") }

  describe "#errors" do
    subject(:errors) { presenter.errors }

    let(:good_quality) { double(:good, good?: true) }
    let(:bad_quality)  { double(:bad,  good?: false) }

    let(:quality_control) { class_double(FlexStationData::SampleQuality, :gc) }

    it "checks for sample errors using the supplied quality control service", :aggregate_failures do
      expect(quality_control).to receive(:call).with(sample, **options).and_return [ good_quality, bad_quality ]

      expect(errors).to eq [ bad_quality ]
    end
  end

  describe "#present" do
    subject(:csv) { presenter.present }

    context "given a valid sample" do
      let(:wells)  { %w[ A1 A2 ] }
      let(:values) { [ [1.3, 1.5], [2.1, 2.7] ] }
      let(:mean)   { [ 1.5, 2.5 ] }

      before do
        allow(sample).to receive(:wells).and_return wells
        allow(sample).to receive(:values).and_return values
        allow(sample).to receive(:mean).and_return mean
      end

      it "returns rows with the sample data" do
        expect(csv).to eq [
          [ "Sample A" ],
          [ "time", "A1", "A2", "mean" ],
          [    0.0,  1.3,  2.1,    1.5 ],
          [    2.0,  1.5,  2.7,    2.5 ],
          []
        ]
      end
    end

    context "given a sample with errors" do
      let(:errors) { [ "an error", "another error" ] }

      before do
        allow(presenter).to receive(:errors).and_return errors
      end

      it "returns rows with the sample errors" do
        expect(csv).to eq [
          [ "Sample A" ],
          [ "an error" ],
          [ "another error" ],
          []
        ]
      end
    end
  end
end
