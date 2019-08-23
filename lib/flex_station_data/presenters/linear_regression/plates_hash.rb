require "flex_station_data/presenters/linear_regression/plate_hash"

module FlexStationData
  module Presenters
    module LinearRegression
      class PlatesHash
        include Concerns::Presenter

        attr_reader :file, :plates, :plate_presenter, :options

        def initialize(file, plates, plate_presenter: PlateHash, **options)
          @file = file
          @plates = plates
          @plate_presenter = plate_presenter
          @options = options
        end

        def present
          plates.flat_map do |plate|
            plate_presenter.present(plate, **options).map do |plate_hash|
              { "file" => file.basename.to_s }.merge(plate_hash)
            end
          end
        end
      end
    end
  end
end
