# frozen_string_literal: true

require "flex_station_data/services/sample_quality"
require "flex_station_data/services/value_quality"

RSpec.describe FlexStationData::SampleQuality do
  describe "#call" do
    subject(:quality) { service.call }

    let(:service) { described_class.new(sample, **options) }
    let(:options) { { an_option: "setting" } }
    let(:sample)  { instance_double(FlexStationData::Sample, values: values) }

    def good
      FlexStationData::ValueQuality::Good.instance
    end

    def bad(description)
      FlexStationData::ValueQuality::Bad.new(description)
    end

    let(:value_qualities) do
      [
        [ :a, bad("Wrong")   ],
        [ :b, good           ],
        [ :c, bad("Wrong")   ],
        [ :d, good           ],
        [ :e, bad("Invalid") ]
      ]
    end

    let(:values)    { value_qualities.map(&:first) }
    let(:qualities) { value_qualities.map(&:last) }

    before do
      value_qualities.each do |value, quality|
        allow(FlexStationData::ValueQuality).to receive(:call).with(value, **options).and_return(quality)
      end
    end

    it "checks the quality of each value", :aggregate_failures do
      service.call
      value_qualities.each do |value, _quality|
        expect(FlexStationData::ValueQuality).to have_received(:call).with(value, **options).once
      end
    end

    it "returns an array of unique qualities", :aggregate_failures do
      quality.zip(qualities.uniq(&:to_s)).each do |actual, expected|
        expect(actual).to be expected
      end
    end
  end
end
