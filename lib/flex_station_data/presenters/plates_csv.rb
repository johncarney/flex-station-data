require "flex_station_data/presenters/plate_csv"

module FlexStationData
  module Presenters
    class PlatesCsv
      include Concerns::Presenter

      attr_reader :file, :plates, :plate_presenter, :options

      def initialize(file, plates, plate_presenter: PlateCsv, **options)
        @file = file
        @plates = plates
        @plate_presenter = plate_presenter
        @options = options
      end

      def plates_csv
        plates.flat_map do |plate|
          plate_presenter.present(plate, **options)
        end
      end

      def present
        [ ["File: #{file.to_path}"], *plates_csv ]
      end
    end
  end
end
