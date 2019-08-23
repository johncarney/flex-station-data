require "flex_station_data/presenters/linear_regression/sample_hash"

module FlexStationData
  module Presenters
    module LinearRegression
      class PlateHash
        include Concerns::Presenter

        attr_reader :plate, :sample_presenter, :options

        delegate :times, :samples, to: :plate

        def initialize(plate, sample_presenter: SampleHash, **options)
          @plate = plate
          @sample_presenter = sample_presenter
          @options = options
        end

        def present
          samples.map do |sample|
            { "plate" => plate.label }.merge(sample_presenter.present(times, sample, **options))
          end
        end
      end
    end
  end
end
