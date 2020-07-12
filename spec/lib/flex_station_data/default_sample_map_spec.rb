# frozen_string_literal: true

require "flex_station_data/default_sample_map"

require "support/sample_map_matchers"

RSpec.describe FlexStationData::DefaultSampleMap do
  include SampleMapMatchers

  context "given a plate with 2 rows and 6 columns, and 3 wells per sample" do
    subject(:sample_map) { described_class.new(2, 6, 3) }

    it { is_expected.to map_sample("1").to  "A1",  "A2",  "A3" }
    it { is_expected.to map_sample("2").to  "B1",  "B2",  "B3" }
    it { is_expected.to map_sample("3").to  "A4",  "A5",  "A6" }
    it { is_expected.to map_sample("4").to  "B4",  "B5",  "B6" }
  end
end
