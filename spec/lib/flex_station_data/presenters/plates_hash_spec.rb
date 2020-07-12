# frozen_string_literal: true

require "flex_station_data/presenters/plates_hash"

require "flex_station_data/plate"

RSpec.describe FlexStationData::Presenters::PlatesHash do
  let(:presenter) { described_class.new(file, plates, **options) }

  let(:file)    { Pathname("tmp/source-file.csv") }
  let(:options) { { option: double(:option) } }

  let(:plate_presenter) { FlexStationData::Presenters::PlateHash }

  describe "#present" do
    subject(:hash) { presenter.present }

    let(:plate_1) { instance_double(FlexStationData::Plate, :plate_1) }
    let(:plate_2) { instance_double(FlexStationData::Plate, :plate_2) }
    let(:plates)  { [ plate_1, plate_2 ] }

    it "returns an array of hashes with data from the file's plates" do
      plate_1_data = [ { a: 1, b: 2 }, { a: 3, b: 4 } ]
      plate_2_data = [ { a: 5, b: 6 } ]

      expect(plate_presenter).to receive(:present).with(plate_1, **options).and_return plate_1_data
      expect(plate_presenter).to receive(:present).with(plate_2, **options).and_return plate_2_data

      expected_hash = [ *plate_1_data, *plate_2_data ].map { |row| { "file" => file.basename.to_s }.merge(row) }
      expect(hash).to eq expected_hash
    end
  end
end
