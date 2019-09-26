require "flex_station_data/services/value_quality"

require "support/value_quality_matchers"

RSpec.describe FlexStationData::ValueQuality do
  include ValueQualityMatchers

  describe "#call" do
    subject(:quality) { described_class.new(value, threshold: threshold).call }

    let(:threshold) { nil }

    context "with a nil value" do
      let(:value) { nil }

      it { is_expected.to be_bad("No data") }
    end

    context %(with a value of "#SAT") do
      let(:value) { "#SAT" }

      it { is_expected.to be_bad("Saturated") }
    end

    context "with a non-numeric value" do
      let(:value) { "Hi" }

      it { is_expected.to be_bad("Invalid data") }
    end

    context "given a numeric value" do
      let(:value) { 1.0 }

      it { is_expected.to be_good }
    end

    context "when a threshold is specified" do
      let(:threshold){ 100.0 }

      context "with a value below the threshold" do
        let(:value) { 99.9 }

        it { is_expected.to be_bad("Below threshold") }
      end

      context "with a value equal to the threshold" do
        let(:value) { threshold }

        it { is_expected.to be_good }
      end

      context "with a value above the threshold" do
        let(:value) { 100.1 }

        it { is_expected.to be_good }
      end
    end
  end
end
