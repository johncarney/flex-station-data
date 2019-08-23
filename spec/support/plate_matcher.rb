require "rspec/expectations"

require "flex_station_data/plate"

module PlateMatcher
  extend RSpec::Matchers::DSL

  matcher :be_a_plate do
    def values_match?(actual)
      return true unless defined?(@with_values)

      @with_values.all? do |name, value|
        actual.send(name) == value
      end
    end

    match do |actual|
      actual.is_a?(FlexStationData::Plate) && values_match?(actual)
    end

    chain :with do |label, times, temperatures, samples|
      @with_values = {
        label:        label,
        times:        times,
        temperatures: temperatures,
        samples:      samples
      }
    end
  end
end
