require "flex_station_data/presenters/plates_csv"

require "flex_station_data/plate"

RSpec.describe FlexStationData::Presenters::PlatesCsv do
  let(:presenter) { described_class.new(file, plates, plate_presenter: plate_presenter, **options) }

  let(:file)            { Pathname("tmp/source-file.csv") }
  let(:options)         { { option: double(:option) } }
  let(:plate_presenter) { class_double(FlexStationData::Presenters::PlateCsv, :plate_presenter) }

  describe "#present" do
    subject(:csv) { presenter.present }

    let(:plate_1) { instance_double(FlexStationData::Plate, :plate_1) }
    let(:plate_2) { instance_double(FlexStationData::Plate, :plate_2) }
    let(:plates)  { [ plate_1, plate_2 ] }

    it "returns rows with data from the file's plates" do
      plate_1_data = double(:plate_1_data)
      plate_2_data = double(:plate_2_data)

      expect(plate_presenter).to receive(:present).with(plate_1, **options).and_return plate_1_data
      expect(plate_presenter).to receive(:present).with(plate_2, **options).and_return plate_2_data

      expect(csv).to eq [
        [ "File: source-file.csv" ],
        plate_1_data,
        plate_2_data
      ]
    end
  end
end

