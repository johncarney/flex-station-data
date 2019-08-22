module FlexStationData
  class Readings
    attr_reader :label, :values

    def initialize(label, values)
      @label = label
      @values = values
    end

    # def self.means(*readings, label: "means")
    #   new(label, readings.map(&values).transpose.map { |values| values.sum / values.size.to_f })
    # end
  end
end
