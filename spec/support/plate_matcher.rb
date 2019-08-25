require "rspec/expectations"

require "flex_station_data/plate"

module PlateMatcher
  extend RSpec::Matchers::DSL

  matcher :be_a_plate do
    def actual_matches_expected?(actual, expected)
      case expected
      when Array
        actual.zip(expected).all? do |actual_item, expected_item|
          actual_matches_expected?(actual_item, expected_item)
        end
      when FlexStationData::Sample
        actual_matches_expected?(actual.label, expected.label) && actual_matches_expected?(actual.readings, expected.readings)
      when FlexStationData::Readings
        actual.label == expected.label && actual.values == expected.values
      else
        actual == expected
      end
    end

    def values_match?(actual)
      return true unless defined?(@with_values)

      @with_values.all? do |name, value|
        actual_matches_expected?(actual.send(name), value)
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
