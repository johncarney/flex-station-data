# frozen_string_literal: true

require "rspec/expectations"

module SampleMapMatchers
  extend RSpec::Matchers::DSL

  matcher :map_sample do |label|
    match do |map|
      map[label] == @wells
    end

    chain :to do |*wells|
      @wells = wells
    end
  end
end
