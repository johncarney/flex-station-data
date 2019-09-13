require "flex_station_data/presenters/sample_hash"

module FlexStationData
  module Presenters
    class PlateHash
      include Concerns::Presenter

      attr_reader :plate, :options

      delegate :times, :samples, to: :plate

      def initialize(plate, **options)
        @plate = plate
        @options = options
      end

      def present
        samples.map do |sample|
          { "plate" => plate.label }.merge(SampleHash.present(times, sample, **options))
        end
      end
    end
  end
end
