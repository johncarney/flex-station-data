require "spec_helper"

require "flex_station_data/wells"

RSpec.describe FlexStationData::Wells do
  describe "#readings" do
    subject(:readings) { wells.readings(well_label) }

    let(:plate_readings_matrix) do
      [
        [ :top_left,    :top_right ],
        [ :bottom_left, :bottom_right ]
      ]
    end

    let(:wells) { described_class.new(plate_readings_matrix) }

    context "given a well label" do
      let(:well_label) { "B2" }

      it { is_expected.to be_a FlexStationData::Readings }

      it "sets the readings label to the well label" do
        expect(readings.label).to eq well_label
      end
    end

    context 'given "A1" as the well label' do
      let(:well_label) { "A1" }

      it "sets the readings values from the top left of plate readings matrix" do
        expect(readings.values).to eq :top_left
      end
    end

    context 'given "A2" as the well label' do
      let(:well_label) { "A2" }

      it "sets the readings values from the top right of plate readings matrix" do
        expect(readings.values).to eq :top_right
      end
    end

    context 'given "B1" as the well label' do
      let(:well_label) { "B1" }

      it "sets the readings values from the bottom left of plate readings matrix" do
        expect(readings.values).to eq :bottom_left
      end
    end

    context 'given "B2" as the well label' do
      let(:well_label) { "B2" }

      it "sets the readings values from the bottom right of plate readings matrix" do
        expect(readings.values).to eq :bottom_right
      end
    end
  end
end
