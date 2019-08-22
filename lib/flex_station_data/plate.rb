module FlexStationData
  class Plate
    attr_reader :times, :temperatures, :samples

    def initialize(times, temperatures, samples)
      @times = times
      @temperatures = temperatures
      @samples = samples
    end
  end
end
