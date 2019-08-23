require "flex_station_data/presenters/plate_csv"

module FlexStationData
  module Presenters
    class PlatesCsv
      include Concerns::Presenter

      attr_reader :file, :plates

      def initialize(file, plates)
        @file = file
        @plates = plates
      end

      def present(&plate_presenter)
        plate_presenter ||= PlateCsv
        [ ["File: #{file.to_path}"], *plates.flat_map(&plate_presenter) ]
      end
    end
  end
end
