# frozen_string_literal: true

require "active_support/core_ext"

require "flex_station_data/concerns/service"

module FlexStationData
  class ComputeMean
    include Concerns::Service

    attr_reader :values

    def initialize(values)
      @values = values
    end

    def call
      Float(values.sum) / values.size
    rescue ArgumentError, TypeError, NoMethodError
      nil
    end
  end
end
