require "flex_station_data/presenters/plate_hash"

require "flex_station_data/presenters/sample_hash"
require "flex_station_data/plate"

RSpec.describe FlexStationData::Presenters::PlateHash do
  let(:presenter) { described_class.new(plate, **options) }

  let(:label)   { "the plate" }
  let(:times)   { [ 0.0, 2.0 ] }
  let(:options) { { option: double(:option) } }
  let(:plate)   { instance_double(FlexStationData::Plate, :plate_1, label: label, times: times, samples: samples) }

  let(:sample_presenter) { FlexStationData::Presenters::SampleHash }

  describe "#present" do
    subject(:hash) { presenter.present }

    let(:sample_1) { instance_double(FlexStationData::Plate, :plate_1) }
    let(:sample_2) { instance_double(FlexStationData::Plate, :plate_2) }
    let(:samples)  { [ sample_1, sample_2 ] }

    it "returns an array of hashes with data from the file's plates" do
      sample_1_data = { a: 1, b: 2 }
      sample_2_data = { a: 5, b: 6 }

      expect(sample_presenter).to receive(:present).with(times, sample_1, **options).and_return sample_1_data
      expect(sample_presenter).to receive(:present).with(times, sample_2, **options).and_return sample_2_data

      expected_hash = [ sample_1_data, sample_2_data ].map { |row| { "plate" => label }.merge(row) }
      expect(hash).to eq expected_hash
    end
  end
end
