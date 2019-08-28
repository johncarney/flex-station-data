require "rspec/expectations"

require "flex_station_data/wells"

module WellsMatchers
  extend RSpec::Matchers::DSL

  matcher :match_wells do |expected|
    match do |actual|
      actual.matrix == expected.matrix
    end
  end
  alias_matcher :wells_matching, :match_wells
end
