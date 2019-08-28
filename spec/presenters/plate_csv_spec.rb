require "flex_station_data/presenters/plate_csv"
require "flex_station_data/plate"
require "flex_station_data/sample"

RSpec.describe FlexStationData::Presenters::PlateCsv do
  let(:presenter) { described_class.new(plate, sample_presenter: sample_presenter, **options) }

  let(:plate) { instance_double(FlexStationData::Plate, :plate, label: "X", times: times, samples: samples) }

  let(:times)            { double(:times) }
  let(:options)          { { option: double(:option) } }
  let(:sample_presenter) { class_double(FlexStationData::Presenters::SampleCsv, :sample_presenter) }

  describe "#present" do
    subject(:csv) { presenter.present }

    let(:sample_1) { instance_double(FlexStationData::Sample, :sample_1) }
    let(:sample_2) { instance_double(FlexStationData::Sample, :sample_2) }
    let(:samples)  { [ sample_1, sample_2 ] }

    it "returns rows with data from the plate's samples" do
      sample_1_data = double(:sample_1_data)
      sample_2_data = double(:sample_2_data)

      expect(sample_presenter).to receive(:present).with(times, sample_1, **options).and_return sample_1_data
      expect(sample_presenter).to receive(:present).with(times, sample_2, **options).and_return sample_2_data

      expect(csv).to eq [
        [ "Plate X" ],
        sample_1_data,
        sample_2_data
      ]
    end
  end
end
