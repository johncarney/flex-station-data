# frozen_string_literal: true

require "rspec/expectations"

require "flex_station_data/wells"

module WellsMatchers
  extend RSpec::Matchers::DSL

  matcher :be_a_wells_object do
    match do |actual|
      actual.is_a?(FlexStationData::Wells) && (@matrix.blank? || actual.matrix == @matrix)
    end

    chain :with_matrix do |matrix|
      @matrix = matrix
    end
  end

  matcher :match_wells do |expected|
    match do |actual|
      actual.matrix == expected.matrix
    end
  end
  alias_matcher :wells_matching, :match_wells
end
