require "support/plate_matcher"
require "flex_station_data/services/parse_plate"

RSpec.describe FlexStationData::ParsePlate do
  include PlateMatcher

  let(:label)   { "the plate" }
  let(:service) { described_class.new(label, plate_data) }

  describe "#data_blocks" do
    let(:plate_data) do
      [
        ["first bit",      nil],
        ["guff",           nil],
        ["~End",           nil],
        ["second bit",     nil],
        ["more guff",      nil],
        ["~End",           nil],
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
    let(:plate_data) { double(:plate_data) }
    let(:block_1)    { double(:block_1) }
    let(:block_2)    { double(:block_2) }
    let(:block_3)    { double(:block_3) }

    before do
      allow(service).to receive(:data_blocks).and_return [ block_1, block_2, block_3 ]
    end

    it "builds a Plate object from the plate data", :aggregate_failures do
      times = double(:times)
      temperatures = double(:temperatures)
      wells = double(:wells)
      expect(FlexStationData::ParsePlateReadings).to receive(:call).with(block_1).and_return([ times, temperatures, wells ])

      samples = double(:samples)
      expect(FlexStationData::ParsePlateSamples).to receive(:call).with(block_2, wells).and_return samples

      expect(service.call).to be_a_plate.with(label, times, temperatures, samples)
    end
  end
end
