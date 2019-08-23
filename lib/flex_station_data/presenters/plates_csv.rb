require "flex_station_data/presenters/plate_csv"

module FlexStationData
  module Presenters
    class PlatesCsv
      include Concerns::Presenter

      attr_reader :file, :plates, :plate_presenter

      def initialize(file, plates, plate_presenter: PlateCsv)
        @file = file
        @plates = plates
        @plate_presenter = plate_presenter
      end

      def present
        [ ["File: #{file.to_path}"], *plates.flat_map(&plate_presenter) ]
      end
    end
  end
end
