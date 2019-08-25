require "rspec/expectations"

require "flex_station_data/readings"

module ReadingsMatchers
  extend RSpec::Matchers::DSL

  matcher :match_readings do |expected|
    match do |actual|
      actual.label == expected.label && actual.values == expected.values
    end
  end
  alias_matcher :readings_matching, :match_readings
end
