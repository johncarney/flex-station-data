require "flex_station_data/presenters/sample_csv"

module FlexStationData
  module Presenters
    class PlateCsv
      include Concerns::Presenter

      attr_reader :plate, :sample_presenter, :options

      delegate :times, :samples, to: :plate

      def initialize(plate, sample_presenter: SampleCsv, **options)
        @plate = plate
        @sample_presenter = sample_presenter
        @options = options
      end

      def samples_csv
        samples.flat_map do |sample|
          sample_presenter.present(times, sample, **options)
        end
      end

      def present
        [ ["Plate #{plate.label}"], *samples_csv ]
      end
    end
  end
end
