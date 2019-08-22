module FlexStationData
  class Sample
    attr_reader :label, :readings

    def initialize(label, readings)
      @label = label
      @readings = readings
    end
  end
end
