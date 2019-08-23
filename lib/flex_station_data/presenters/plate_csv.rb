require "flex_station_data/presenters/sample_csv"

module FlexStationData
  module Presenters
    class PlateCsv
      include Concerns::Presenter

      attr_reader :plate

      delegate :times, :samples, to: :plate

      def initialize(plate, sample_presenter: SampleCsv)
        @plate = plate
        @sample_presenter = sample_presenter
      end

      def sample_presenter
        @sample_presenter.method(:present).curry(2)[times]
      end

      def present
        [ ["Plate #{plate.label}"], *samples.flat_map(&sample_presenter) ]
      end
    end
  end
end
