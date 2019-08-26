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

      def present
        [
          [ "File: #{file.basename.to_path}" ],
          *plates_csv
        ]
      end

      private

      def plates_csv
        plates.flat_map do |plate|
          plate_presenter.present(plate, **options)
        end
      end
    end
  end
end
