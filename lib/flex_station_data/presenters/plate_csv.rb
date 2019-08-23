require "flex_station_data/presenters/sample_csv"

module FlexStationData
  module Presenters
    class PlateCsv
      include Concerns::Presenter

      attr_reader :plate

      delegate :times, :samples, to: :plate

      def initialize(plate)
        @plate = plate
      end

      def present(&sample_presenter)
        sample_presenter ||= SampleCsv
        sample_presenter = sample_presenter.curry(2)[times]
        [ ["Plate #{plate.label}"], *samples.flat_map(&sample_presenter) ]
      end
    end
  end
end
