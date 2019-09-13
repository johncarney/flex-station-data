require "csv"

require "flex_station_data/services/parse_plate"
require "flex_station_data/sample"

require "support/wells_matchers"

RSpec.describe FlexStationData::ParsePlate do
  include WellsMatchers

  let(:label)   { "the plate" }
  let(:service) { described_class.new(label, plate_data) }

  describe "#data_blocks" do
    let(:plate_data) do
      [
        ["first bit",      nil],
        ["guff",           nil],
        ["~End ",          nil],
        ["second bit",     nil],
        ["more guff",      nil],
        ["~End ",          nil],
        ["last bit",       nil],
        ["guff guff guff", nil]
      ]
    end

    it "splits the plate data into blocks separated by '~End' rows" do
      expected_data = [
        [
          ["first bit",      nil],
          ["guff",           nil]
        ],
        [
          ["second bit",     nil],
          ["more guff",      nil]
        ],
        [
          ["last bit",       nil],
          ["guff guff guff", nil]
        ]
      ]
      expect(service.data_blocks).to eq expected_data
    end
  end

  describe "#call" do
    let(:plate_block_csv) do
      <<~CSV
        ,Temperature(¡C),1,2,,,,,,,,,,,,,,,,,,,
        0:00:00,23.4,2254.922,1842.306,,,,,,,,,,,,,,,,,,,,,,
        ,,2195.008,1803.211,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,
        0:02:00,23.5,2343.58,1903.978,,,,,,,,,,,,,,,,,,,,,,
        ,,2248.472,1858.705,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,
        ~End,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        Group: Unknowns,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
        Sample,Wells,Value,R,Result,MeanResult,SD,CV,,,,,,,,,,,,,,,,,,,,,,,,,
        1,A1,0.791,R, , , , ,,,,,,,,,,,,,,,,,,,,,,,,,
         ,A2,0.684,R, , , , ,,,,,,,,,,,,,,,,,,,,,,,,,
        2,B1,0.84,R, , , , ,,,,,,,,,,,,,,,,,,,,,,,,,
         ,B2,0.61,R, , , , ,,,,,,,,,,,,,,,,,,,,,,,,,
        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
      CSV
    end

    let(:plate_data) { CSV.parse(plate_block_csv, headers: false) }

    it "builds a Plate object from the plate data", :aggregate_failures do
      times = [ 0.0, 2.0 ]
      temperatures = [ 23.4, 23.5 ]
      plate_wells = FlexStationData::Wells.new Matrix[
        [ [2254.922, 2343.580], [1842.306, 1903.978] ],
        [ [2195.008, 2248.472], [1803.211, 1858.705] ]
      ]
      sample_map = { "1" => %w[A1 A2], "2" => %w[B1 B2] }

      expected_plate = instance_double(FlexStationData::Plate, :plate)
      expect(FlexStationData::Plate).to receive(:new).with(label, times, temperatures, wells_matching(plate_wells), sample_map).and_wrap_original do |method, *args|
        method.call(*args)
        expected_plate
      end

      expect(service.call).to be expected_plate
    end
  end
end
