# frozen_string_literal: true

require "flex_station_data/presenters/plate_hash"

module FlexStationData
  module Presenters
    class PlatesHash
      include Concerns::Presenter

      attr_reader :file, :plates, :options

      def initialize(file, plates, **options)
        @file = file
        @plates = plates
        @options = options
      end

      def present
        base = { "file" => file.basename.to_s }
        plates.flat_map do |plate|
          PlateHash.present(plate, **options).map(&base.method(:merge))
        end
      end
    end
  end
end
