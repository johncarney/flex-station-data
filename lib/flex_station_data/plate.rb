module FlexStationData
  class Plate
    attr_reader :label, :times, :temperatures, :samples

    def initialize(label, times, temperatures, samples)
      @label = label
      @times = times
      @temperatures = temperatures
      @samples = samples
    end
  end
end
